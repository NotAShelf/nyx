import { Widget } from "../imports";
import { queryExact } from "./global";
const { Box, Icon, Label, Button } = Widget;

/**
 * Builds a desktop item with a specific name and label.
 * It uses the `queryExact` function to find the exact application based on its name.
 * Then, it creates a button widget with the application's icon and label.
 * When the button is clicked, it launches the application.
 *
 * @function buildDesktopItem
 * @param {string} name - The name of the application.
 * @param {string} label - The label of the desktop item.
 * @returns {Object} The desktop item widget.
 */
export const buildDesktopItem = (name: string, label: string): object => {
    const app = queryExact(name);
    return Button({
        className: "desktopIcon",
        cursor: "pointer",
        onClicked: () => app.launch(),
        child: Box({
            vertical: true,
            children: [
                Icon({
                    icon: app.iconName,
                    size: 48,
                }),
                Label({
                    className: "desktopIconLabel",
                    label,
                }),
            ],
        }),
    });
};
