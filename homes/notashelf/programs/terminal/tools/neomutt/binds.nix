{
  binds = [
    {
      # Reply to a group or mailing list.
      action = "group-reply";
      key = "R";
      map = [
        "index"
        "pager"
      ];
    }

    {
      # Move to the previous box in the sidebar.
      action = "sidebar-prev";
      key = "\\cK";
      map = [
        "index"
        "pager"
      ];
    }

    {
      # Move to the next box in the sidebar.
      action = "sidebar-next";
      key = "\\cJ";
      map = [
        "index"
        "pager"
      ];
    }

    {
      # Open the current box highlighted in the sidebar.
      action = "sidebar-open";
      key = "\\cO";
      map = [
        "index"
        "pager"
      ];
    }

    {
      # View the raw contents of a message.
      action = "view-raw-message";
      key = "Z";
      map = [
        "index"
        "pager"
      ];
    }
  ];
}
