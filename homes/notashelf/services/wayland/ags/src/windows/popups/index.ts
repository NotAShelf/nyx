import { Widget } from "../../imports";

// Widgets
import { BrightnessPopup } from "./modules/brightnessPopup";
import { VolumePopup } from "./modules/volumePopup";

const Popups = () =>
	Widget.Window({
		name: "popups",
		className: "popups",
		anchor: ["bottom", "right"],
		layer: "overlay",
		margins: [0, 12, 8, 0],
		child: Widget.Box({
			vertical: true,
			children: [BrightnessPopup(), VolumePopup()],
		}),
	});

export default Popups;
