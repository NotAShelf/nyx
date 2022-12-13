{
  config,
  pkgs,
  ...
}:
# this should block *most* junk sites
# make sure to ALWAYS lock commit hash
{
  networking.extraHosts =
    builtins.readFile (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/StevenBlack/hosts/92be34d60800598e59c6c23fef9be42e049672b6/alternates/fakenews-gambling-porn/hosts";
      sha256 = "zf5/OSdxBnwyD7bqEJnA/b78y8UI57XQ/eQTe3Wxw8I=";
      # blocks fakenews, gambling and coomer sites
    })
    + builtins.readFile (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/shreyasminocha/shady-hosts/8a8c67e798b12de05c8543f4ea1ab43aa3e02803/hosts";
      sha256 = "qtV4GJ+uRdwUKZV0h2K9a7SKS8Z8KuacEI87o4eqy8s=";
      # blocks some shady fed sites
    })
    + builtins.readFile (pkgs.fetchurl {
      # blocks crypto phishing scams
      url = "https://raw.githubusercontent.com/MetaMask/eth-phishing-detect/c5ce8011f42dda652b8348ad98fac63d5b328f39/src/hosts.txt";
      sha256 = "b3HvaLxnUJZOANUL/p+XPNvu9Aod9YLHYYtCZT5Lan0=";
    })
    + builtins.readFile (pkgs.fetchurl {
      # generic ads
      url = "https://raw.githubusercontent.com/AdAway/adaway.github.io/04f783e1d9f48bd9ac156610791d7f55d0f7d943/hosts.txt";
      sha256 = "mp0ka7T0H53rJ3f7yAep3ExXmY6ftpHpAcwWrRWzWYI=";
    });
}
