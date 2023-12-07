import { Utils, App } from './imports.js';

// Windows
import { launcher } from './windows/launcher/index.js';
import { Bar } from './windows/bar/index.js';
import { Desktop } from './windows/desktop/index.js';
import { Popups } from './windows/popups/index.js';
import { Music } from './windows/music/index.js';

const scss = App.configDir + '/scss/main.scss';
const css = App.configDir + '/style.css';

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

Utils.subprocess(
  [
    'inotifywait',
    '--recursive',
    '--event',
    'create,modify',
    '-m',
    App.configDir + '/style',
  ],
  () => {
    print('scss change detected');
    Utils.exec(`sassc ${scss} ${css}`);
    App.resetCss();
    App.applyCss(css);
  },
);
