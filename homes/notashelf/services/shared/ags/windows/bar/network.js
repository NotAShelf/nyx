import { Network, Widget, Utils } from "../../imports.js";
import { Icon } from "../../icons.js";
const { Stack, Box, Button, Label } = Widget;

const WifiIndicator = () =>
	Box({
		children: [
			Widget.Label({
				has_tooltip: true,
				binds: [
					[
						"label",
						Network.wifi,
						"strength",
						(/** @type {number} */ strength) => {
							if (strength < 0.1) return Icon.wifi.none;
							if (strength < 0.26) return Icon.wifi.bad;
							if (strength < 0.51) return Icon.wifi.low;
							if (strength < 0.76) return Icon.wifi.normal;
							if (strength < 10000) return Icon.wifi.good;
							else return Icon.wifi.none;
						},
					],
				],
				connections: [
					[
						Network.wifi,
						(self) =>
							(self.tooltip_markup = `Strength: ${
								Network.wifi.strength * 100
							}`),
					],
				],
			}),
		],
	});

const WiredIndicator = () =>
	Label({
		cursor: "pointer",
		binds: [
			[
				"label",
				Network.wired,
				"internet",
				(internet) => {
					if (internet === "connected") return Icon.wired.power;
					if (internet === "connecting") return Icon.wired.poweroff;
					if (internet === "disconnected") return Icon.wired.poweroff;
					return Icon.wired.poweroff;
				},
			],
		],
		connections: [
			[
				Network.wired,
				(self) =>
					(self.tooltip_markup = `Connection: ${Network.wired.internet}`),
			],
		],
	});

export const NetworkWidget = () =>
	Button({
		className: "network",
		cursor: "pointer",
		onClicked: () => Utils.exec("nm-connection-editor"),
		child: Stack({
			binds: [["shown", Network, "primary", (p) => p || "wifi"]],
			items: [
				["wifi", WifiIndicator()],
				["wired", WiredIndicator()],
			],
		}),
	});
