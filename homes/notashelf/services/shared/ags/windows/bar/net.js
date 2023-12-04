import { Network, Widget } from "../../imports.js";
const { Box } = Widget;

const Net = Widget.Icon({
	className: "networkModule",
	binds: [
		[
			"icon",
			Network,
			"connectivity",
			(conn) => {
				if (conn == "none") return "";
				if (Network.primary == "wired") return "network-wired";

				return Network.wifi.icon_name;
			},
		],
		[
			"tooltip-text",
			Network,
			"connectivity",
			(conn) => {
				if (conn == "none") return "";
				if (Network.primary == "wired") return "Wired";

				return Network.wifi.ssid;
			},
		],
	],
});

export const NetworkWidget = () =>
	Box({
		className: "networkWidget",
		vertical: true,
		children: [Net],
	});
