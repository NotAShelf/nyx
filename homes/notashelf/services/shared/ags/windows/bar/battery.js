import { Widget, Battery } from "../../imports.js";
const { Box, Label } = Widget;

const BatIcon = () =>
	Label({
		className: "batIcon",
		connections: [
			[
				Battery,
				(icon) => {
					icon.toggleClassName("charging", Battery.charging);
					icon.toggleClassName("charged", Battery.charged);
					icon.toggleClassName("low", Battery.percent < 30);
				},

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
	/*
	const directoryItemCount = Utils.exec(
		`sh -c "ls -A /sys/class/backlight | wc -l"`,
	);
	console.log(directoryItemCount);
	const directoryNotEmpty = parseInt(directoryItemCount) > 0;
	console.log(directoryNotEmpty);
	*/

	return Box({
		className: "battery",
		child: BatIcon(),
		binds: [["visible", Battery, "available"]],
	});
};
