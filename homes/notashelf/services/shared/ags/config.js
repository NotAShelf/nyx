import { Utils, App } from "./imports.js";
import DirectoryMonitorService from "./services/directoryMonitorService.js";

// Windows
import { launcher } from "./windows/launcher/index.js";
import { Bar } from "./windows/bar/index.js";
import { Desktop } from "./windows/desktop/index.js";
import { Popups } from "./windows/popups/index.js";
import { Music } from "./windows/music/index.js";

// Compile scss into css
const compileScss = () => {
	Utils.exec(
		`sassc ${App.configDir}/scss/main.scss ${App.configDir}/style.css`,
	);
};

// Apply compield css
const applyScss = () => {
	// Compile scss
	compileScss();
	console.log("Scss compiled");

	// Apply compiled css
	App.resetCss();
	App.applyCss(`${App.configDir}/style.css`);
	console.log("Compiled css applied");
};

const compileAndApplyScss = () => {
	compileScss();
	applyScss();
};

// Compile and apply scss
compileAndApplyScss();

// Check for any changes
DirectoryMonitorService.recursiveDirectoryMonitor(`${App.configDir}/scss`);
DirectoryMonitorService.connect("changed", compileAndApplyScss);

// Main config
export default {
	style: `${App.configDir}/style.css`,
	windows: [launcher, Bar(), Desktop(), Popups(), Music()],
	closeWindowDelay: {
		launcher: 300,
		music: 300,
	},
};
