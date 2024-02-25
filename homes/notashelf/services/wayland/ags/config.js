import { App } from "./js/imports.js";
const css = App.configDir + "/style.css";

// Windows
import { AppLauncher } from "./js/windows/launcher/index.js";
import { Bar } from "./js/windows/bar/index.js";
import { Desktop } from "./js/windows/desktop/index.js";
import { Popups } from "./js/windows/popups/index.js";

App.connect("config-parsed", () => print("config parsed"));

// Main config
export default {
    style: css,
    windows: [AppLauncher(), Bar(), Desktop(), Popups()],
    closeWindowDelay: {
        launcher: 300,
        music: 300,
    },
};
