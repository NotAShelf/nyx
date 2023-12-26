import { Utils, App } from "./js/imports.js";

// Windows
import { AppLauncher } from "./js/windows/launcher/index.js";
import { Bar } from "./js/windows/bar/index.js";
import { Desktop } from "./js/windows/desktop/index.js";
import { TopLeft, TopRight } from "./js/windows/desktop/corners.js";
import { Popups } from "./js/windows/popups/index.js";
import { Music } from "./js/windows/music/index.js";

const scss = App.configDir + "/scss/main.scss";
const css = App.configDir + "/style.css";

reloadCss("Compiling scss...");

// Main config
export default {
    style: css,
    windows: [
        AppLauncher(),
        Bar(),
        Desktop(),
        TopLeft(),
        TopRight(),
        Popups(),
        Music(),
    ],
    closeWindowDelay: {
        launcher: 300,
        music: 300,
    },
};

function reloadCss(message) {
    /* eslint-disable no-undef */
    print(message);
    Utils.exec(`sassc ${scss} ${css}`);
    App.resetCss();
    App.applyCss(css);
}

Utils.monitorFile(
    `${App.configDir}/scss`,
    reloadCss("scss change detected, reloading stylesheets"),
    "directory",
);
