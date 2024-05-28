import { Network, Widget, Utils } from "../../../imports";
import {
	getWifiIcon,
	getWifiTooltip,
	getWiredIcon,
	getWiredTooltip,
} from "../../../utils/network.js";
const { Stack, Button, Label } = Widget;

const WifiIndicator = () =>
	Label({ has_tooltip: true })
		.bind("label", Network.wifi, "strength", getWifiIcon)
		.bind("tooltip-text", Network.wifi, "strength", getWifiTooltip);

const WiredIndicator = () =>
	Label({ cursor: "pointer" })
		.bind("label", Network.wired, "internet", getWiredIcon)
		.bind("tooltip-text", Network.wired, "internet", getWiredTooltip);

export const NetworkWidget = () =>
	Button({
		className: "network",
		cursor: "pointer",
		onClicked: () => Utils.exec("nm-connection-editor"),
		child: Stack({
			shown: Network.bind("primary").as(
				(/** @type {any} */ p) => p || "wifi",
			),
			children: {
				wifi: WifiIndicator(),
				wired: WiredIndicator(),
			},
		}),
	});
