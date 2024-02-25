{
  programs.neovim-flake.settings.vim = {
    filetree = {
      nvimTree = {
        enable = true;
        openOnSetup = true;
        disableNetrw = true;
        updateFocusedFile.enable = true;

        hijackUnnamedBufferWhenOpening = true;
        hijackCursor = true;

        /*
        hijackDirectories = {
          enable = true;
          autoOpen = true;
        };
        */

        git = {
          enable = true;
          showOnDirs = false;
          timeout = 500;
        };

        view = {
          cursorline = false;
          width = 35;
        };

        renderer = {
          indentMarkers.enable = true;
          rootFolderLabel = false; # inconsistent

          icons = {
            modifiedPlacement = "after";
            gitPlacement = "after";
            show.git = true;
            show.modified = true;
          };
        };

        diagnostics.enable = true;

        modified = {
          enable = true;
          showOnDirs = false;
          showOnOpenDirs = true;
        };

        actions = {
          changeDir.enable = false;
          changeDir.global = false;
          openFile.windowPicker.enable = true;
        };

        mappings = {
          toggle = "<C-w>";
        };
      };
    };
  };
}
