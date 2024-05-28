const Icons = {
	settings: "org.gnome.Settings-symbolic",
	tick: "object-select-symbolic",
	audio: {
		mic: {
			muted: "microphone-disabled-symbolic",
			unmuted: "microphone-sensitivity-high-symbolic",
		},
		volume: {
			muted: "audio-volume-muted-symbolic",
			low: "audio-volume-low-symbolic",
			medium: "audio-volume-medium-symbolic",
			high: "audio-volume-high-symbolic",
			overamplified: "audio-volume-overamplified-symbolic",
		},
		type: {
			headset: "audio-headphones-symbolic",
			speaker: "audio-speakers-symbolic",
			card: "audio-card-symbolic",
		},
		mixer: "tool-symbolic",
	},
	apps: {
		apps: "view-app-grid-symbolic",
		search: "folder-saved-search-symbolic",
	},
	bluetooth: {
		enabled: "bluetooth-active-symbolic",
		disabled: "bluetooth-disabled-symbolic",
	},
	brightness: {
		indicator: "display-brightness-symbolic",
		keyboard: "keyboard-brightness-symbolic",
		screen: ["󰛩", "󱩎", "󱩏", "󱩐", "󱩑", "󱩒", "󱩓", "󱩔", "󱩕", "󱩖", "󰛨"],
	},
	header: {
		refresh: "view-refresh-symbolic",
		settings: "settings-symbolic",
		power: "system-shutdown-symbolic",
	},
	media: {
		play: "media-playback-start-symbolic",
		pause: "media-playback-pause-symbolic",
		next: "media-skip-forward-symbolic",
		previous: "media-skip-backward-symbolic",
		player: "multimedia-player-symbolic",
	},
	mpris: {
		fallback: "audio-x-generic-symbolic",
		shuffle: {
			enabled: "media-playlist-shuffle-symbolic",
			disabled: "media-playlist-no-shuffle-symbolic",
		},
		loop: {
			none: "media-playlist-no-repeat-symbolic",
			track: "media-playlist-repeat-song-symbolic",
			playlist: "media-playlist-repeat-symbolic",
		},
		playing: "media-playback-pause-symbolic",
		paused: "media-playback-start-symbolic",
		stopped: "media-playback-stop-symbolic",
		prev: "media-skip-backward-symbolic",
		next: "media-skip-forward-symbolic",
	},
	notifications: {
		noisy: "preferences-system-notifications-symbolic",
		silent: "notifications-disabled-symbolic",
		critical: "messagebox_critical-symbolic",
		chat: "notification-symbolic",
		close: "window-close-symbolic",
	},
	powermenu: {
		sleep: "weather-clear-night-symbolic",
		reboot: "system-reboot-symbolic",
		logout: "system-log-out-symbolic",
		shutdown: "system-shutdown-symbolic",
		lock: "system-lock-screen-symbolic",
		close: "window-close-symbolic",
	},
	recorder: {
		recording: "media-record-symbolic",
	},
	trash: {
		full: "user-trash-full-symbolic",
		empty: "user-trash-symbolic",
	},
	ui: {
		send: "mail-send-symbolic",
		arrow: {
			right: "pan-end-symbolic",
			left: "pan-start-symbolic",
			down: "pan-down-symbolic",
			up: "pan-up-symbolic",
		},
	},
	speaker: {
		overamplified: "\uf14b",
		high: "\ue050",
		medium: "\ue04d",
		low: "\ue04e",
		muted: "\ue04f",
	},
	microphone: {
		overamplified: "\ue029",
		high: "\ue029",
		medium: "\ue029",
		low: "\ue029",
		muted: "\ue02b",
	},
	wired: {
		power: "󰈀",
		poweroff: "󱘖",
	},
	wifi: {
		none: "󰤭",
		bad: "󰤠",
		low: "󰤟",
		normal: "󰤢",
		good: "󰤨",
	},
	system: {
		cpu: "org.gnome.SystemMonitor-symbolic",
		ram: "drive-harddisk-solidstate-symbolic",
		temp: "temperature-symbolic",
	},
};

export default Icons;
