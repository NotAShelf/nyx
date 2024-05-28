export const getLauncherIcon = (
    self: { child: { label: string } },
    windowName: string,
    visible: any,
) => {
    windowName === "launcher" && (self.child.label = visible ? "󱢡" : "󱢦");
};
