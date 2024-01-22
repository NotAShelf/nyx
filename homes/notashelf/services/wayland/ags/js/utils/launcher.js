export const getLauncherIcon = (self, windowName, visible) => {
    windowName === "launcher" && (self.child.label = visible ? "󱢡" : "󱢦");
};
