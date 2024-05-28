import { Widget, SystemTray } from "../../../imports";
import { getTrayItems } from "../../../utils/tray";
const { Box, EventBox, Label, Revealer } = Widget;

const RevIcon = () =>
	Label({
		className: "trayChevron",
		label: "",
	});

const TrayItems = () =>
	Box({
		className: "trayIcons",
		vertical: true,
		setup: (self) => {
			self.hook(SystemTray, getTrayItems);
		},
	});

export const Tray = () =>
	EventBox({
		onPrimaryClick: (self) => {
			self.child.children[0].label = self.child.children[1].revealChild
				? ""
				: "";
			self.child.children[1].revealChild =
				!self.child.children[1].revealChild;
		},
		child: Box({
			className: "tray",
			vertical: true,
			children: [
				RevIcon(),
				Revealer({
					transition: "slide_up",
					child: TrayItems(),
				}),
			],
		}),
	});
