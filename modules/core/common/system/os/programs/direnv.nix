{
  config,
  pkgs,
  ...
}: {
  programs.direnv = {
    enable = true;

    # shut up. SHUT UP
    silent = true;

    # faster, persistent implementation of use_nix and use_flake
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv.override {
        nix = config.nix.package;
      };
    };

    # enable loading direnv in nix-shell nix shell or nix develop
    loadInNixShell = true;

    direnvrcExtra = ''
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      declare -A direnv_layout_dirs

      # https://github.com/direnv/direnv/wiki/Customizing-cache-location#hashed-directories
      direnv_layout_dir() {
        echo "''${direnv_layout_dirs[$PWD]:=$(
          echo -n "$XDG_CACHE_HOME"/direnv/layouts/
          echo -n "$PWD" | ${pkgs.perl}/bin/shasum | cut -d ' ' -f 1
        )}"
      }

      # Usage: daemonize <name> [<command> [...<args>]]
      #
      # Starts the command in the background with an exclusive lock on $name.
      #
      # If no command is passed, it uses the name as the command.
      #
      # Logs are in .direnv/$name.log
      #
      # To kill the process, run `kill $(< .direnv/$name.pid)`.
      daemonize() {
        local name=$1
        shift
        local pid_file=$(direnv_layout_dir)/$name.pid
        local log_file=$(direnv_layout_dir)/$name.log

        if [[ $# -lt 1 ]]; then
          cmd=$name
        else
          cmd=$1
          shift
        fi

        if ! has "$cmd"; then
          echo "ERROR: $cmd not found"
          return 1
        fi

        mkdir -p "$(direnv_layout_dir)"

        # Open pid_file on file descriptor 200
        exec 200>"$pid_file"

        # Check that we have exclusive access
        if ! flock --nonblock 200; then
          echo "daemonize[$name] is already running as pid $(< "$pid_file")"
          return
        fi

        # Start the process in the background. This requires two forks to escape the
        # control of bash.

        # First fork
        (
          # Second fork
          (
            echo "daemonize[$name:$BASHPID]: starting $cmd $*" >&2

            # Record the PID for good measure
            echo "$BASHPID" >&200

            # Redirect standard file descriptors
            exec 0</dev/null
            exec 1>"$log_file"
            exec 2>&1
            # Used by direnv
            exec 3>&-
            exec 4>&-

            # Run command
            exec "$cmd" "$@"
          ) &
        ) &

        # Release that file descriptor
        exec 200>&-
      }
    '';
  };
}
