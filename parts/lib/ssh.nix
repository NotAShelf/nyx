{lib, ...}: let
  inherit (lib.lists) singleton;

  # <https://github.com/NuschtOS/nixos-modules/blob/933e4dce6ad0e159526fa08649f880ecb3c6d937/lib/ssh.nix>
  mkPubkeyFor = name: type: publicKey: {
    "${name}-${type}" = {
      extraHostNames = singleton name;
      publicKey = "${type} ${publicKey}";
    };
  };
in {
  inherit mkPubkeyFor;
}
