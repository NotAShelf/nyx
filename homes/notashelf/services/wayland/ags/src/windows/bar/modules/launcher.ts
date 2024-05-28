import { Widget, App } from "../../../imports";
import { getLauncherIcon } from "../../../utils/launcher";
const { Button, Label } = Widget;

export const LauncherIcon = () =>
	Button({
		vexpand: false,
		className: "launcherIcon",
		cursor: "pointer",
		child: Label("󱢦"),
		onClicked: () => App.toggleWindow("launcher"),
		setup: (self) => {
			self.hook(App, getLauncherIcon, "window-toggled");
		},
	});
