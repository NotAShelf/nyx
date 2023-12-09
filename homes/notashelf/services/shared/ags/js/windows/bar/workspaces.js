import { Utils, Widget, Hyprland } from "../../imports.js";
const { execAsync } = Utils;
const { Box } = Widget;

/** @param {any} arg */
const dispatch = (arg) => () =>
    Utils.execAsync(`hyprctl dispatch workspace ${arg}`);

export const Workspaces = () =>
    Box({
        className: "workspaces",
        vertical: true,
        child: Box({
            vertical: true,
            children: Array.from({ length: 10 }, (_, i) => i + 1).map((i) =>
                Widget.Button({
                    cursor: "pointer",
                    properties: [["index", i]],
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
                    on_scroll_up: () => dispatch("m+1"),
                    on_scroll_down: () => dispatch("m-1"),
                }),
            ),
            connections: [
                [
                    Hyprland,
                    (self) =>
                        self.children.forEach((btn) => {
                            btn.className =
                                btn._index === Hyprland.active.workspace.id
                                    ? "focused"
                                    : "";
                            btn.visible = Hyprland.workspaces.some(
                                (ws) => ws.id === btn._index,
                            );
                        }),
                ],
            ],
        }),
    });
