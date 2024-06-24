import { App, Notifications } from "./imports";

// Windows
import AppLauncher from "./windows/launcher/index";
import Bar from "./windows/bar/index";
import Desktop from "./windows/desktop/index";
import Popups from "./windows/popups/index";
import Notifs from "./windows/notifications/index";
import Media from "./windows/music/index";

App.connect("config-parsed", () => console.log("Config parsed!"));

Notifications.popupTimeout = 5000;
Notifications.forceTimeout = false;
Notifications.cacheActions = true;

// Main config
App.config({
    style: "./style.css",
    closeWindowDelay: {
        launcher: 300,
        music: 300,
    },
});

function addWindows(windows: (typeof Window)[]): void {
    windows.forEach((win) => App.addWindow(win));
}

// Spawn windows, or load them into memory
try {
    addWindows([AppLauncher(), Bar(), Media(), Desktop(), Popups(), Notifs()]);
} catch (error) {
    console.error(error);
    App.quit();
}

export {};
