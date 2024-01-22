{
  macros = [
    {
      # toggle the sidebar's visibility and refresh/redraw the screen
      action = "<enter-command>toggle sidebar_visible<enter><refresh>";
      key = "B";
      map = ["index"];
    }
    {
      action = "<enter-command>toggle sidebar_visible<enter><redraw-screen>";
      key = "B";
      map = ["pager"];
    }
  ];
}
