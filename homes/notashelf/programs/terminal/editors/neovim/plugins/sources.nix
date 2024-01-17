{pkgs, ...}: let
  inherit (pkgs.vimUtils) buildVimPlugin;
  pins = import ./npins;
in {
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
    src = pkgs.fetchFromGitHub {
      owner = "bennypowers";
      repo = "nvim-regexplainer";
      rev = "4250c8f3c1307876384e70eeedde5149249e154f";
      hash = "sha256-15DLbKtOgUPq4DcF71jFYu31faDn52k3P1x47GL3+b0=";
    };
  };

  specs-nvim = buildVimPlugin {
    name = "specs.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "edluffy";
      repo = "specs.nvim";
      rev = "2743e412bbe21c9d73954c403d01e8de7377890d";
      hash = "sha256-mYTzltCEKO8C7BJ3WrB/iFa1Qq1rgJlcjW6NYHPfmPk=";
    };
  };

  deferred-clipboard = buildVimPlugin {
    name = "deferred-clipboard";
    src = pkgs.fetchFromGitHub {
      owner = "EtiamNullam";
      repo = "deferred-clipboard.nvim";
      rev = "810a29d166eaa41afc220cc7cd85eeaa3c43b37f";
      hash = "sha256-nanNQEtpjv0YKEkkrPmq/5FPxq+Yj/19cs0Gf7YgKjU=";
    };
  };

  data-viewer-nvim = buildVimPlugin {
    name = "data-viewer.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "VidocqH";
      repo = "data-viewer.nvim";
      rev = "40ddf37bb7ab6c04ff9e820812d1539afe691668";
      hash = "sha256-D5hvLhsYski11H9qiDDL2zlZMtYmbpHgpewiWR6C7rE=";
    };
  };

  vim-nftables = buildVimPlugin {
    name = "vim-nftables";
    src = pkgs.fetchFromGitHub {
      owner = "awisse";
      repo = "vim-nftables";
      rev = "bc29309080b4c7e1888ffb1a830846be16e5b8e7";
      hash = "sha256-L1x3Hv95t/DBBrLtPBKrqaTbIPor/NhVuEHVIYo/OaA=";
    };
  };
}
