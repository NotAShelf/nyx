{
  environment = {
    # Disable X11 libraries on headless systems to save as much space as we possibly can.
    # Setting this to true might need some packages to be overlayed, as they may depend
    # on X libraries but provide an override to avoid the dependency.
    noXlibs = true;

    # On servers, print the URL instead of trying to open them with a browser.
    variables.BROWSER = "echo";
  };
}
