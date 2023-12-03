import { Widget } from "../../imports.js";
const { Button, Label } = Widget;

export const PowerMenu = () =>
	Button({
		className: "powerMenu",
		cursor: "pointer",
		child: Label(""),
	});
