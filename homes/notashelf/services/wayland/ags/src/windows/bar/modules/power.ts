import { Widget } from "../../../imports";
const { Button, Label } = Widget;

export const PowerMenu = () =>
	Button({
		vexpand: false,
		className: "power",
		cursor: "pointer",
		child: Label(""),
	});
