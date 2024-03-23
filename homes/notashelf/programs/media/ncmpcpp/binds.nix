{
  programs.ncmpcpp.bindings = [
    {
      key = "j";
      command = "scroll_down";
    }
    {
      key = "k";
      command = "scroll_up";
    }
    {
      key = "J";
      command = ["select_item" "scroll_down"];
    }
    {
      key = "K";
      command = ["select_item" "scroll_up"];
    }
  ];
}
