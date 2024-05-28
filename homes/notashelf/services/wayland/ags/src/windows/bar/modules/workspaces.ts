import { Widget, Hyprland } from "../../../imports";
import { getFocusedWorkspace } from "../../../utils/hyprland";
const { Box, Button } = Widget;
const { messageAsync } = Hyprland;

export const Workspaces = () =>
	Box({
		className: "workspaces",
		child: Box({
			vertical: true,
			children: Array.from({ length: 10 }, (_, i) => i + 1).map((i) =>
				Button({
					cursor: "pointer",
					attribute: { index: i },
					onClicked: () => messageAsync(`dispatch workspace ${i}`),
					onSecondaryClick: () =>
						messageAsync(`dispatch movetoworkspacesilent ${i}`),
				}),
			),

			setup: (self) => {
				self.hook(Hyprland, getFocusedWorkspace);
			},
		}),
	});
