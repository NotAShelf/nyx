import { Utils, App } from "./imports.js";
import DirectoryMonitorService from "./services/directoryMonitorService.js";

// Windows
import { launcher } from "./windows/launcher/launcher.js";
import { Bar } from "./windows/bar/bar.js";
import { Desktop } from "./windows/desktop/desktop.js";
import { Popups } from "./windows/popups/popups.js";
import { Music } from "./windows/music/music.js";

const css = App.configDir + "/style.css";
const compileScss = () => {
	Utils.exec(
		`sassc ${App.configDir}/scss/main.scss ${App.configDir}/style.css`,
	);
};

// Apply css
const applyScss = () => {
	// Compile scss
	compileScss();
	console.log("Scss compiled");

	// Apply compiled css
	App.resetCss();
	App.applyCss(`${App.configDir}/style.css`);
	console.log("Compiled css applied");
};

// Apply css then check for changes
applyScss();

// Check for any changes
DirectoryMonitorService.recursiveDirectoryMonitor(`${App.configDir}/scss`);
DirectoryMonitorService.connect("changed", applyScss);

// Main config
export default {
	style: `${App.configDir}/style.css`,
	windows: [launcher, Bar(), Desktop(), Popups(), Music()],
	closeWindowDelay: {
		launcher: 300,
		music: 300,
	},
};

Utils.subprocess(
	[
		"inotifywait",
		"--recursive",
		"--event",
		"create,modify",
		"-m",
		App.configDir + "/style",
	],
	() => {
		print("scss change detected");
		Utils.exec(
			`sassc ${App.configDir}/scss/main.scss ${App.configDir}/style.css`,
		);
		App.resetCss();
		App.applyCss(css);
	},
);
