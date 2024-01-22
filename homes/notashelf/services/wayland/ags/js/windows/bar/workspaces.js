import { Utils, Widget, Hyprland } from "../../imports.js";
import { getFocusedWorkspace } from "../../utils/hyprland.js";
const { execAsync } = Utils;
const { Box } = Widget;

export const Workspaces = () =>
    Box({
        className: "workspaces",
        child: Box({
            vertical: true,
            children: Array.from({ length: 10 }, (_, i) => i + 1).map((i) =>
                Widget.Button({
                    cursor: "pointer",
                    attribute: { index: i },
                    onClicked: () =>
                        execAsync([
                            "hyprctl",
                            "dispatch",
                            "workspace",
                            `${i}`,
                        ]).catch(console.error),
                    onSecondaryClick: () =>
                        execAsync([
                            "hyprctl",
                            "dispatch",
                            "movetoworkspacesilent",
                            `${i}`,
                        ]).catch(console.error),
                }),
            ),

            setup: (self) => {
                self.hook(Hyprland, getFocusedWorkspace);
            },
        }),
    });
