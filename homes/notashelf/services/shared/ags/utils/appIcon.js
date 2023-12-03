import { Widget, Utils, Applications, App } from "../imports.js";
const { Button, Icon } = Widget;

function queryExact(appName) {
	return (
		Applications.list.filter(
			(app) => app.name.toLowerCase() === appName.toLowerCase(),
		)[0] ?? Applications.query(appName)[0]
	);
}

export default ({
	appName,
	onClicked = () => queryExact(appName).launch(),
	icon = queryExact(appName).iconName,
	size = 36,
	...props
}) => {
	const appIcon = Button({
		onClicked,
		child: Icon({
			icon,
			size,
			...props,
		}),
	});
	return appIcon;
};
