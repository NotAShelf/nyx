import { Widget, Utils } from "../../imports.js";
const { Button, Label } = Widget;

export const Swallow = () =>
	Button({
		className: "swallow",
		cursor: "pointer",
		child: Label("󰊰"),
		onClicked: () => Utils.exec("hyprctl-swallow"),
	});
