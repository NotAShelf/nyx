import { Widget } from "../../imports.js";
const { Window, Box, CenterBox } = Widget;

// Widgets
import { toggleLauncher } from "./launcher.js";
import { Workspaces } from "./workspaces.js";
import { Tray } from "./tray.js";
import { BatteryWidget } from "./battery.js";
import { Clock } from "./clock.js";
import { PowerMenu } from "./power.js";
import { Swallow } from "./swallow.js";
import { Lock } from "./lock.js";
import { BluetoothWidget } from "./bluetooth.js";
import { AudioWidget } from "./audio.js";
import { NetworkWidget } from "./net.js";

const Top = () =>
	Box({
		className: "barTop",
		vertical: true,
		vpack: "start",
		children: [
			toggleLauncher(),
			Box({
				className: "utilButtons",
				vertical: true,
				children: [Lock()],
			}),
		],
	});

const Center = () =>
	Box({
		vertical: true,
		children: [Workspaces()],
	});

const Bottom = () =>
	Box({
		className: "barBottom",
		vertical: true,
		vpack: "end",
		children: [
			Tray(),
			Box({
				className: "systemInfo",
				vertical: true,
				children: [
					BatteryWidget(),
					BluetoothWidget(),
					AudioWidget(),
					Swallow(),
					NetworkWidget(),
					/*
					Widget.Label({
						className: "wifiIcon",
						label: "󰤨",
					}),
					*/
				],
			}),
			Clock(),
			PowerMenu(),
		],
	});

export const Bar = ({ monitor } = {}) =>
	Window({
		//className: 'bar',
		name: "bar",
		anchor: ["top", "bottom", "left"],
		exclusivity: "exclusive",
		layer: "bottom",
		margins: [12, 0, 12, 12],
		monitor,
		child: CenterBox({
			className: "bar",
			vertical: true,
			startWidget: Top(),
			centerWidget: Center(),
			endWidget: Bottom(),
		}),
	});
