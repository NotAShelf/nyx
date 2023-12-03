import { Widget, Applications, App } from "../../imports.js";
const { Button, Label } = Widget;

function queryExact(appName) {
	return (
		Applications.list.filter(
			(app) => app.name.toLowerCase() === appName.toLowerCase(),
		)[0] ?? Applications.query(appName)[0]
	);
}

export const Swallow = () =>
	Button({
		className: "swallow",
		cursor: "pointer",
		child: Label("󰊰"),
		onClicked: () => queryExact("hyprctl-swallow").launch(),
	});
