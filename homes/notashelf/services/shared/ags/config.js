import { Utils, App } from "./js/imports.js";

// Windows
import { launcher } from "./js/windows/launcher/index.js";
import { Bar } from "./js/windows/bar/index.js";
import { Desktop } from "./js/windows/desktop/index.js";
import { Popups } from "./js/windows/popups/index.js";
import { Music } from "./js/windows/music/index.js";

const scss = App.configDir + "/scss/main.scss";
const css = App.configDir + "/style.css";

Utils.exec(`sassc ${scss} ${css}`);

// Main config
export default {
    style: css,
    windows: [launcher, Bar(), Desktop(), Popups(), Music()],
    closeWindowDelay: {
        launcher: 300,
        music: 300,
    },
};

function reloadCss() {
    console.log("scss change detected");
    Utils.exec(`sassc ${scss} ${css}`);
    App.resetCss();
    App.applyCss(css);
}

Utils.monitorFile(`${App.configDir}/scss`, reloadCss, "directory");
