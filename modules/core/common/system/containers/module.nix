{
  # this imports all container directories unconditionally, regardless of whether or not
  # they are included in containers.enabledContainers option definition
  # however, as a safeguard, we are required to check if a container is actually meant to be enabled
  # so each container does it's own "builtins.elem ..." bullshit before evaluating the container
  # configuration - hacky? yes. working? also yes.
  imports = [
    ./alpha # sandbox
    ./beta # postgresql
  ];
}
