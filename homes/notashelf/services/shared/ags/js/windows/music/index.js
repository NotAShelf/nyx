import { Widget, App, Mpris } from "../../imports.js";
const { Window, Box, Label } = Widget;
import PopupWindow from "../../utils/popupWindow.js";
import { playerControls } from "./musicControls.js";

const truncateString = (str, maxLength) =>
    str.length > maxLength ? `${str.slice(0, maxLength)}...` : str;

const playerArtist = () =>
    Box({
        className: "playerArtist",
        children: [
            Label({
                className: "artistIcon",
                label: "󰀉",
            }),
            Label({
                className: "artist",
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
            }),
        ],
    });

const playerCover = () =>
    Widget.Overlay({
        child: Box({
            className: "playerCover",
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
        }),
        overlays: [
            Box({
                className: "playerCoverOverlay",
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
            }),
        ],
    });

const playerTitle = () =>
    Label({
        className: "playerTitle",
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

const playerProgress = () =>
    Widget.ProgressBar({
        className: "playerProgress",
        connections: [
            [
                1000,
                (self) => {
                    const player = Mpris.players[0];
                    if (!player) return;

                    self.value = 0.5 /*player.position / player.length*/;
                },
            ],
        ],
    });

Mpris.connect("player-closed", () => App.closeWindow("music"));

export const Music = ({ monitor } = {}) =>
    PopupWindow({
        name: "music",
        anchor: ["right"],
        layer: "overlay",
        margins: [0, 12, 0, 0],
        transition: "slide_left",
        popup: true,
        child: Box({
            className: "music",
            vertical: true,
            children: [
                Box({
                    className: "playerArtistBox",
                    children: [playerArtist()],
                }),
                Box({
                    className: "playerCoverBox",
                    children: [playerCover()],
                }),
                Box({
                    className: "playerTitleBox",
                    children: [playerTitle()],
                }),
                Box({
                    className: "playerProgressBox",
                    children: [playerProgress()],
                }),

                Box({
                    className: "playerControlsBox",
                    children: [playerControls()],
                    hpack: "start",
                }),
            ],
        }),
    });
