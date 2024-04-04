# Cheat sheet

## Show GC roots

```shell
nix-store --gc --print-roots | grep -v "<hostName>" | column -t | sort -k3 -k1
```

## List all packages

```shell
nix-store -q --requisites /run/current-system | cut -d- -f2- | sort | uniq
```

You can add a `wc -l` at the end of the above command, but that will not be an accurate representation of
your package count, as the same package can be repeated with different versions.

## Find biggest packages

```shell
nix path-info -hsr /run/current-system/ | sort -hrk2 | head -n10
```

## Find biggest closures (packages including dependencies)

```shell
nix path-info -hSr /run/current-system/ | sort -hrk2 | head -n10
```

## Show package dependencies as tree

> Assuming `hello` is in PATH

```shell
nix-store -q --tree $(realpath $(which hello))
```

## Show package dependencies including size

```shell
nix path-info -hSr nixpkgs#hello
```

## Show the things that will change on reboot

```shell
diff <(nix-store -qR /run/current-system) <(nix-store -qR  /run/booted-system)
```
