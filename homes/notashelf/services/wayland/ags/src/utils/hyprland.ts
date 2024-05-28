import { Hyprland } from "../imports";

export const getFocusedWorkspace = (self) =>
    self.children.forEach((btn) => {
        btn.className =
            btn.attribute.index === Hyprland.active.workspace.id
                ? "focused"
                : "";
        btn.visible = Hyprland.workspaces.some(
            (ws) => ws.id === btn.attribute.index,
        );
    });
