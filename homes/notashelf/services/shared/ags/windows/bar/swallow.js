import { Widget, Utils } from "../../imports.js";
const { Button, Label } = Widget;

const swallowStatus = Utils.exec("hyprctl-swallow query");

export const Swallow = () =>
	Button({
		className: "swallow",
		cursor: "pointer",
		child: Label("󰊰"),
		onClicked: (button) => {
			Utils.exec("hyprctl-swallow"),
				(button.tooltip_markup = `Swallow: ${
					JSON.parse(swallowStatus).status
				}`);
		},
	});
