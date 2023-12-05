import { Widget, App, Applications, Utils, Hyprland } from "../../imports.js";
import PopupWindow from "../../utils/popupWindow.js";
const { Gdk } = imports.gi;

const WINDOW_NAME = "launcher";

const truncateString = (str, maxLength) =>
	str.length > maxLength ? `${str.slice(0, maxLength)}...` : str;

const AppItem = (app) =>
	Widget.Button({
		className: "launcherApp",
		onClicked: () => {
			App.closeWindow(WINDOW_NAME);
			Hyprland.sendMessage(`dispatch exec gtk-launch ${app.desktop}`);
			++app.frequency;
		},
		setup: (self) => (self.app = app),
		child: Widget.Box({
			children: [
				Widget.Icon({
					className: "launcherItemIcon",
					icon: app.iconName || "",
					size: 24,
				}),
				Widget.Box({
					className: "launcherItem",
					vertical: true,
					vpack: "center",
					children: [
						Widget.Label({
							className: "launcherItemTitle",
							label: app.name,
							xalign: 0,
							vpack: "center",
							truncate: "end",
						}),
						!!app.description &&
							Widget.Label({
								className: "launcherItemDescription",
								label:
									truncateString(app.description, 75) || "",
								wrap: true,
								xalign: 0,
								justification: "left",
								vpack: "center",
							}),
					],
				}),
			],
		}),
	});

const Launcher = () => {
	const list = Widget.Box({ vertical: true });

	const entry = Widget.Entry({
		className: "launcherEntry",
		hexpand: true,
		text: "-",
		onAccept: ({ text }) => {
			const isCommand = text.startsWith(">");
			const appList = Applications.query(text || "");
			if (isCommand === true) {
				App.toggleWindow(WINDOW_NAME);
				Utils.execAsync(text.slice(1));
			} else if (appList[0]) {
				App.toggleWindow(WINDOW_NAME);
				appList[0].launch();
			}
		},
		onChange: ({ text }) =>
			list.children.map((item) => {
				item.visible = item.app.match(text);
			}),
	});

	return Widget.Box({
		className: "launcher",
		vertical: true,
		children: [
			entry,
			Widget.Scrollable({
				hscroll: "never",
				css: `
          min-width: 240px;
          min-height: ${Gdk.Screen.get_default().get_height() - 84}px;
        `,
				child: list,
			}),
		],
		connections: [
			[
				App,
				(_, name, visible) => {
					if (name !== WINDOW_NAME) return;

					list.children = Applications.list.map(AppItem);

					entry.text = "";
					if (visible) entry.grab_focus();
				},
			],
		],
	});
};

export const launcher = PopupWindow({
	name: WINDOW_NAME,
	anchor: ["top", "bottom", "right"],
	margins: [4, 12, 0, 4],
	layer: "overlay",
	transition: "slide_left",
	popup: true,
	visible: false,
	focusable: true,
	child: Launcher(),
});
