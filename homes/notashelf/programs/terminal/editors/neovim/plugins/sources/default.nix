{
  self,
  pkgs,
  ...
}: let
  inherit (self) pins;
  inherit (pkgs) fetchFromGitHub;
  inherit (pkgs.vimUtils) buildVimPlugin;

  sources = {
    hmts = buildVimPlugin {
      name = "hmts.nvim";
      src = pins."hmts.nvim";
    };

    smart-splits = buildVimPlugin {
      name = "smart-splits";
      src = pins."smart-splits.nvim";
    };

    slides-nvim = buildVimPlugin {
      name = "slides.nvim";
      src = pins."slides.nvim";
    };

    regexplainer = buildVimPlugin {
      name = "nvim-regexplainer";
      src = fetchFromGitHub {
        owner = "bennypowers";
        repo = "nvim-regexplainer";
        rev = "4250c8f3c1307876384e70eeedde5149249e154f";
        hash = "sha256-15DLbKtOgUPq4DcF71jFYu31faDn52k3P1x47GL3+b0=";
      };
    };

    specs-nvim = buildVimPlugin {
      name = "specs.nvim";
      src = fetchFromGitHub {
        owner = "notashelf";
        repo = "specs.nvim";
        rev = "0792aaebf8cbac0c8545c43ad648b98deb83af42";
        hash = "sha256-doHE/3bRuC8lyYxMk927JmwLfiy7aR22+i+BNefEGJ4=";
      };
    };

    deferred-clipboard = buildVimPlugin {
      name = "deferred-clipboard";
      src = fetchFromGitHub {
        owner = "EtiamNullam";
        repo = "deferred-clipboard.nvim";
        rev = "810a29d166eaa41afc220cc7cd85eeaa3c43b37f";
        hash = "sha256-nanNQEtpjv0YKEkkrPmq/5FPxq+Yj/19cs0Gf7YgKjU=";
      };
    };

    data-viewer-nvim = buildVimPlugin {
      name = "data-viewer.nvim";
      src = fetchFromGitHub {
        owner = "VidocqH";
        repo = "data-viewer.nvim";
        rev = "40ddf37bb7ab6c04ff9e820812d1539afe691668";
        hash = "sha256-D5hvLhsYski11H9qiDDL2zlZMtYmbpHgpewiWR6C7rE=";
      };
    };

    vim-nftables = buildVimPlugin {
      name = "vim-nftables";
      src = fetchFromGitHub {
        owner = "awisse";
        repo = "vim-nftables";
        rev = "bc29309080b4c7e1888ffb1a830846be16e5b8e7";
        hash = "sha256-L1x3Hv95t/DBBrLtPBKrqaTbIPor/NhVuEHVIYo/OaA=";
      };
    };

    neotab-nvim = buildVimPlugin {
      name = "neotab.nvim";
      src = fetchFromGitHub {
        owner = "kawre";
        repo = "neotab.nvim";
        rev = "6c6107dddaa051504e433608f59eca606138269b";
        hash = "sha256-bSFKbjj8fJHdfBzYoQ9l3NU0GAYfdfCbESKbwdbLNSw=";
      };
    };
  };
in
  sources
