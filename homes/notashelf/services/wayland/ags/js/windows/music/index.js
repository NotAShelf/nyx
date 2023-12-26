import { Widget, App, Mpris } from "../../imports.js";
const { Window, Box, Label } = Widget;
import PopupWindow from "../../utils/popupWindow.js";
import { Controls } from "./musicControls.js";

const truncateString = (str, maxLength) =>
    str.length > maxLength ? `${str.slice(0, maxLength)}...` : str;

const Artist = () =>
    Label({
        className: "artist",
        hpack: "start",
        label: "N/A",
        useMarkup: true,
        connections: [
            [
                Mpris,
                (self) => {
                    const player = Mpris.players[0];
                    if (!player) return;

                    self.label = `${truncateString(
                        `${player.trackArtists.join(", ")}`,
                        24,
                    )}`;
                },
            ],
        ],
    });

const CoverArt = () =>
    Box({
        className: "cover",
        connections: [
            [
                Mpris,
                (self) => {
                    const player = Mpris.players[0];
                    if (!player) return;

                    self.css = `background-image: url('${player.coverPath}');`;
                },
            ],
        ],
    });

const Title = () =>
    Label({
        className: "title",
        hpack: "start",
        label: "N/A",
        justification: "center",
        connections: [
            [
                1000,
                (self) => {
                    const player = Mpris.players[0];
                    if (!player) return;

                    self.label = `${truncateString(
                        `${player.trackTitle}`,
                        24,
                    )}`;
                },
            ],
        ],
    });

Mpris.connect("player-closed", () => App.closeWindow("music"));

export const Music = ({ monitor } = {}) =>
    PopupWindow({
        name: "music",
        anchor: ["bottom", "left"],
        layer: "overlay",
        margins: [0, 0, 12, 12],
        transition: "slide_up",
        popup: true,
        child: Box({
            className: "music",
            children: [
                CoverArt(),
                Box({
                    children: [
                        Box({
                            vertical: true,
                            children: [Title(), Artist()],
                        }),
                        Controls(),
                    ],
                }),
            ],
        }),
    });
