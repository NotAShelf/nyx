import { Widget, Utils, Battery } from "../../imports.js";
const { Box, Label } = Widget;

const BatIcon = () =>
	Label({
		className: "batIcon",
		connections: [
			[
				Battery,
				(self) => {
					const icons = [
						["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
						["󰢟", "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"],
					];

					self.label =
						icons[Battery.charging ? 1 : 0][
							Math.floor(Battery.percent / 10)
						].toString();
				},
			],
		],
	});

export const BatteryWidget = () => {
	const directoryItemCount = Utils.exec("ls -A /sys/class/backlight | wc -l");
	const directoryNotEmpty = parseInt(directoryItemCount.trim(), 10) > 0;

	if (directoryNotEmpty) {
		return Box({
			className: "battery",
			child: BatIcon(),
			visible: true,
		});
	}
};
