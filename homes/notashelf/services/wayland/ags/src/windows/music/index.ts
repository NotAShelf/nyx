import { Mpris, Widget } from "../../imports";
import { findPlayer, generateBackground } from "../../utils/mpris";

import PopupWindow from "./modules/popup_window";
import Cover from "./modules/cover";
import { Artists, Title } from "./modules/title_artists";
import TimeInfo from "./modules/time_info";
import Controls from "./modules/controls";
import PlayerInfo from "./modules/player_info";

const Info = (player) =>
	Widget.Box({
		className: "info",
		vertical: true,
		vexpand: false,
		hexpand: false,
		homogeneous: true,

		children: [
			PlayerInfo(player),
			Title(player),
			Artists(player),
			Controls(player),
			TimeInfo(player),
		],
	});

const MusicBox = (player) =>
	Widget.Box({
		className: "music window",
		children: [Cover(player), Info(player)],
	}).bind("css", player, "cover-path", generateBackground);

const Media = () =>
	PopupWindow({
		monitor: 0,
		anchor: ["top"],
		layer: "top",
		margins: [8, 0, 0, 0],
		name: "music",
		child: Widget.Box(),
	}).bind("child", Mpris, "players", (players) => {
		if (players.length == 0) return Widget.Box();
		return MusicBox(findPlayer(players));
	});

export default Media;
