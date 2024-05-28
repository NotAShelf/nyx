import { Widget, Battery } from "../../../imports";
import {
	getBatteryPercentage,
	getBatteryTooltip,
	getBatteryIcon,
} from "../../../utils/battery.js";
const { Button, Box, Label, Revealer } = Widget;

const BatIcon = () =>
	Label({ className: "battery" })
		// NOTE: label needs to be used instead of icon here
		.bind("label", Battery, "percent", getBatteryIcon)
		.bind("tooltip-text", Battery, "percent", getBatteryTooltip);

const BatStatus = () =>
	Revealer({
		transition: "slide_down",
		transition_duration: 200,
		child: Label().bind("label", Battery, "percent", getBatteryPercentage),
	});

export const BatteryWidget = () =>
	Button({
		onPrimaryClick: (self) => {
			self.child.children[1].revealChild =
				!self.child.children[1].revealChild;
		},
		child: Box({
			cursor: "pointer",
			vertical: true,
			children: [BatIcon(), BatStatus()],
			visible: Battery.bind("available"),
		}),
	});
