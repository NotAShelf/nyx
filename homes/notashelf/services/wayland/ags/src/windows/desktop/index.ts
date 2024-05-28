import { Widget } from "../../imports";
const { Window } = Widget;

import DesktopMenu from "./modules/menu";
import DesktopIcons from "./modules/icons";

const Desktop = ({ monitor } = {}) =>
	Window({
		name: "desktop",
		anchor: ["top", "bottom", "left", "right"],
		layer: "bottom",
		monitor,
		child: Widget.Overlay({
			child: DesktopMenu(),
			overlays: [DesktopIcons()],
		}),
	});

export default Desktop;
