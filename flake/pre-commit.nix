{inputs, ...}: {
  imports = [inputs.pre-commit-hooks.flakeModule];

  perSystem.pre-commit = {
    settings.excludes = ["flake.lock"];

    settings.hooks = {
      alejandra.enable = true;
      prettier.enable = true;
      editorconfig-checker.enable = true;
      # Example custom hook for a C project using Make:
      /*
      unit-tests = {
        enable = true;

        # The name of the hook (appears on the report table):
        name = "Unit tests";

        # The command to execute (mandatory):
        entry = "make check";

        # The pattern of files to run on (default: "" (all))
        # see also https://pre-commit.com/#hooks-files
        files = "\\.(c|h)$";

        # List of file types to run on (default: [ "file" ] (all files))
        # see also https://pre-commit.com/#filtering-files-with-types
        # You probably only need to specify one of `files` or `types`:
        types = ["text" "c"];

        # Exclude files that were matched by these patterns (default: [ ] (none)):
        excludes = ["irrelevant\\.c"];

        # The language of the hook - tells pre-commit
        # how to install the hook (default: "system")
        # see also https://pre-commit.com/#supported-languages
        language = "system";

        # Set this to false to not pass the changed files
        # to the command (default: true):
        pass_filenames = false;
      };
      */
    };
  };
}
