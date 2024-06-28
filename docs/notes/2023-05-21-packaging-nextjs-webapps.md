# Packaging NextJS Webapps on Nix

Recently I have had to go through the misfortune of hosting some websites
written with _NextJS_ on my VPS running NixOS, this note entry shall document my
experience and the "easy" path I have chosen.

## Packaging

The websites I hosted were of two variety: those statically exported, and those
that cannot be statically exported.

### Statically Exported Webapps

Statically exported ones are easy to package, because it is a matter of running
`npm build` (or whatever your build script is) with the following NextJS
settings

```js
// next.config.js
module.exports = {
  distDir: "dist", // an artitrary path for your export
  output: "export",
};
```

This will export a static website with a bunch of html files that you can then
serve with nodePackages.serve or a webserver like nginx or apache. And that is
the end of your worries for a statically exported website! No headache, just
write a simple derivation, such as the one below

```nix
# default.nix
{
  buildNpmPackage,
  pkg-config,
  python3,
  ...
}:
buildNpmPackage {
  pname = "your-website";
  version = "0.1";

  src = ./.;
  # needs to be updated everytime you update npm dependencies
  npmDepsHash = "sha256-some-hash";
  # some npm packages may need to be built from source, because nodejs is a *terrible* ecosystem
  nativeBuildInputs = [pkg-config python3];

 # move exported website to $out
 postInstall = ''
    cp -rf dist/* $out
  '';
}
```

and serve its path with a simple tool after building the derivation, I find
nginx to be awfully convenient for doing so, but you may choose caddy if you
prefer.

### Webapps that cannot be statically exported

If your website depends on API routes for some reasons, then Next will not allow
you to do static export. Which means you need to run `next start` in some shape
or form. While a systemd service is certainly a way of doing it (one that I do
not recommend), a oci container works as well if not better.

You can write a "simple" docker image for your oci container to use, such as the
one below

```nix
# dockerImage.nix
{
  pkgs,
  inputs,
  ...
}: {
  dockerImage = pkgs.dockerTools.buildImage {
    config = {
      WorkingDir = "/your-website";
      Cmd = ["npm" "run" "serve"];
    };

    name = "your-website";
    tag = "latest";

    fromImage = pkgs.dockerTools.buildImage {
      name = "node";
      tag = "18-alpine";
    };

    copyToRoot = pkgs.buildEnv {
      name = "image-root";

      paths = with pkgs; [
        # this package is called from a flake.nix alongside the derivation for the website
        inputs.self.packages.${pkgs.stdenv.system}.your-website
        nodejs
        bash
      ];

      pathsToLink = [
        "/bin"
        "/your-website"
      ];
    };
  };
}
```

Then, configure oci-containers module option to pick up the Docker image that
you have built. This is a simplified version of my VPS' container setup. An
example can be found in my
[server module](https://github.com/NotAShelf/nyx/blob/a9e129663ac91302f2fd935351a71cbbd2832f64/modules/core/roles/server/system/services/mkm.nix)

```nix
virtualisation.oci-containers = {
  backend = "podman";
  containers = {
    "website-container" = {
      autoStart = true;
      ports = [
        "3000:3000" # bind container's port 3000 to the outside port 3000 for NextJS
      ];

      extraOptions = ["--network=host"];

      image = "your-website";
      imageFile = inputs.website-flake.packages.${pkgs.stdenv.system}.dockerImage;
    };
  };
};
```

After a rebuild, your system will provision the container and start it on port
**3000**. You can access it with `your-server-ip:3000` in your browser, and even
configure nginx to set up a reverse proxy to assign your domain.

```nix
"example.com" = {
  locations."/".proxyPass = "http://127.0.0.1:3000";
};
```

This will assign your domain to your webserver, and allow outside visitors to
view your "awesome" NextJS webapp.
