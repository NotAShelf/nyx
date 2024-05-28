import { Hyprland, Notifications, Utils, Widget } from "../../imports";
const { Box, Icon, Label, Button, EventBox, Window } = Widget;
const { lookUpIcon } = Utils;

const closeAll = () => {
	Notifications.popups.map((n) => n.dismiss());
};

const NotificationIcon = ({ app_entry, app_icon, image }) => {
	if (image) {
		return Box({
			css: `
        background-image: url("${image}");
        background-size: contain;
        background-repeat: no-repeat;
        background-position: center;
      `,
		});
	}

	if (lookUpIcon(app_icon)) {
		return Icon(app_icon);
	}

	if (app_entry && lookUpIcon(app_entry)) {
		return Icon(app_entry);
	}

	return null;
};

const Notification = (notif) => {
	const icon = Box({
		vpack: "start",
		class_name: "icon",
		// @ts-ignore
		setup: (self: { child: any }) => {
			const icon = NotificationIcon(notif);
			if (icon !== null) self.child = icon;
		},
	});

	const title = Label({
		class_name: "title",
		xalign: 0,
		justification: "left",
		hexpand: true,
		max_width_chars: 24,
		truncate: "end",
		wrap: true,
		label: notif.summary,
		use_markup: true,
	});

	const body = Label({
		class_name: "body",
		hexpand: true,
		use_markup: true,
		xalign: 0,
		justification: "left",
		max_width_chars: 100,
		wrap: true,
		label: notif.body,
	});

	const actions = Box({
		class_name: "actions",
		children: notif.actions
			.filter(({ id }) => id != "default")
			.map(({ id, label }) =>
				Button({
					class_name: "action-button",
					on_clicked: () => notif.invoke(id),
					hexpand: true,
					child: Label(label),
				}),
			),
	});

	return EventBox({
		on_primary_click: () => {
			if (notif.actions.length > 0) notif.invoke(notif.actions[0].id);
		},
		on_middle_click: closeAll,
		on_secondary_click: () => notif.dismiss(),
		child: Box({
			class_name: `notification ${notif.urgency}`,
			vertical: true,

			children: [
				Box({
					class_name: "info",
					children: [
						icon,
						Box({
							vertical: true,
							class_name: "text",
							vpack: "center",

							setup: (self) => {
								if (notif.body.length > 0)
									self.children = [title, body];
								else self.children = [title];
							},
						}),
					],
				}),
				actions,
			],
		}),
	});
};

let lastMonitor;
const Notifs = () =>
	Window({
		name: "notifications",
		anchor: ["top", "right"],
		margins: [8, 8, 8, 0],
		child: Box({
			css: "padding: 1px;",
			class_name: "notifications",
			vertical: true,
			// @ts-ignore
			children: Notifications.bind("popups").transform((popups) => {
				return popups.map(Notification);
			}),
		}),
	}).hook(Hyprland.active, (self) => {
		// prevent useless resets
		if (lastMonitor === Hyprland.active.monitor) return;

		self.monitor = Hyprland.active.monitor.id;
	});

export default Notifs;
