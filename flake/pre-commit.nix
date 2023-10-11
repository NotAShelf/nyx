{inputs, ...}: {
  imports = [inputs.pre-commit-hooks.flakeModule];

  perSystem.pre-commit = {
    check.enable = true;

    settings = {
      # the lockfile should be ignored to avoid breaking flake invocations
      excludes = ["flake.lock"];

      # hooks that we wish to enable
      hooks = {
        alejandra.enable = true;
        prettier.enable = true;
        editorconfig-checker.enable = true;
      };
    };
  };
}
