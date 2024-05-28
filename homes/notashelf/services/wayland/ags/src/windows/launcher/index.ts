import { Widget, App, Applications, Utils, Hyprland } from "../../imports";
import PopupWindow from "../../utils/popupWindow";
const { Box, Button, Icon, Label, Scrollable, Entry } = Widget;

const WINDOW_NAME = "launcher";

const truncateString = (str, maxLength) =>
	str.length > maxLength ? `${str.slice(0, maxLength)}...` : str;

const AppItem = (app) =>
	Button({
		className: "launcherApp",
		onClicked: () => {
			App.closeWindow(WINDOW_NAME);
			Hyprland.messageAsync(`dispatch exec gtk-launch ${app.desktop}`);
			++app.frequency;
		},
		setup: (self) => (self.app = app),
		child: Box({
			children: [
				Icon({
					className: "launcherItemIcon",
					icon: app.iconName || "",
					size: 24,
				}),
				Box({
					className: "launcherItem",
					vertical: true,
					vpack: "center",
					children: [
						Label({
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
	const list = Box({ vertical: true });

	const entry = Entry({
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
		setup: (self) => {
			self.hook(App, (_, name, visible) => {
				if (name !== WINDOW_NAME) return;

				list.children = Applications.list.map(AppItem);

				entry.text = "";
				if (visible) entry.grab_focus();
			});
		},
		children: [
			entry,
			Scrollable({
				hscroll: "never",
				css: "min-width: 250px; min-height: 360px;",
				child: list,
			}),
		],
	});
};

const AppLauncher = () =>
	PopupWindow({
		name: WINDOW_NAME,
		anchor: ["top", "bottom", "right"],
		margins: [13, 13, 0, 13],
		layer: "overlay",
		transition: "slide_down",
		transitionDuration: 150,
		keymode: "on-demand",
		child: Launcher(),
		setup: (self: { keybind: (arg0: string, arg1: () => void) => any }) =>
			self.keybind("Escape", () => {
				App.closeWindow(WINDOW_NAME);
			}),
	});

export default AppLauncher;
