import { Widget } from "../imports.js";
import { queryExact } from "./global.js";
const { Button, Icon } = Widget;

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
