import { Widget, Utils } from "../../../imports";
const { Button, Label } = Widget;

export const Lock = () =>
	Button({
		className: "lock",
		cursor: "pointer",
		child: Label(""),
		onClicked: () => Utils.exec("swaylock"),
	});
