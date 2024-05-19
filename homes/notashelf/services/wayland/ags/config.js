import { App, Notifications } from "./js/imports.js";
const css = App.configDir + "/style.css";

// Windows
import { AppLauncher } from "./js/windows/launcher/index.js";
import { Bar } from "./js/windows/bar/index.js";
import { Desktop } from "./js/windows/desktop/index.js";
import { Popups } from "./js/windows/popups/index.js";
import { Notifs } from "./js/windows/notifications/index.js";
import { Media } from "./js/windows/music/index.js";

App.connect("config-parsed", () => console.log("Config parsed!"));

Notifications.popupTimeout = 5000;
Notifications.forceTimeout = false;
Notifications.cacheActions = true;

// Main config
App.config({
    style: css,
    closeWindowDelay: {
        launcher: 300,
        music: 300,
    },
});

/**
 * @param {any[]} windows
 */
function addWindows(windows) {
    windows.forEach((win) => App.addWindow(win));
}

try {
    addWindows([AppLauncher(), Bar(), Media(), Desktop(), Popups(), Notifs()]);
} catch (e) {
    console.log(e);
    App.quit();
}

export {};
