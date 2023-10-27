_: {
  users.users.root = {
    # I am *not* locking myself out of the system again
    # thank you very much.
    initialPassword = "changeme";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABG2T60uEoq4qTZtAZfSBPtlqWs2b4V4O+EptQ6S/ru"
    ];
  };
}
