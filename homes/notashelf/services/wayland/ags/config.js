import { App, Notifications } from "./js/imports.js";
const css = App.configDir + "/style.css";

// Windows
import { AppLauncher } from "./js/windows/launcher/index.js";
import { Bar } from "./js/windows/bar/index.js";
import { Desktop } from "./js/windows/desktop/index.js";
import { Popups } from "./js/windows/popups/index.js";
import { Notifs } from "./js/windows/notifications/index.js";
import { Media } from "./js/windows/music/index.js";

App.connect("config-parsed", () => print("config parsed"));

Notifications.popupTimeout = 5000;
Notifications.forceTimeout = false;
Notifications.cacheActions = true;

// Main config
export default {
    style: css,
    closeWindowDelay: {
        launcher: 300,
        music: 300,
    },
};

/**
 * @param {any[]} windows
 */
function addWindows(windows) {
    windows.forEach((win) => App.addWindow(win));
}

addWindows([AppLauncher(), Bar(), Media(), Desktop(), Popups(), Notifs()]);
