import { Widget, Utils, App } from "../../imports.js";
const { Button, Label } = Widget;

export const toggleLauncher = () =>
	Button({
		className: "launcher",
		cursor: "pointer",
		child: Label("󱢦"),
		onClicked: () => App.toggleWindow("launcher"),
		connections: [
			[
				App,
				(self, windowName, visible) => {
					windowName === "launcher" &&
						(self.child.label = visible ? "󱢡" : "󱢦");
				},
				"window-toggled",
			],
		],
	});
