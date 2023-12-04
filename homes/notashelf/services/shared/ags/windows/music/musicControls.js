import { Widget, Mpris } from '../../imports.js';
const { Box, Button, Label } = Widget;

export const uwustagramControls = () => Box({
    className: 'uwustagramControls',
    hpack: 'center',
    children: [
        Button({
            className: 'controlsPrev',
            label: '󰒮',
            onClicked: () => Mpris.players[0].previous()
        }),
        Button({
            className: 'controlsPlayPause',
            label: '󰐍',
            onClicked: () => Mpris.players[0].playPause(),
            connections: [[Mpris, self => {
                const player = Mpris.players[0];
                if (!player)
                    return;

                self.label = `${player !== null && player.playBackStatus == 'Playing' ? '󰏦' : '󰐍'}`;
            }]]
        }),
        Button({
            className: 'controlsNext',
            label: '󰒭',
            onClicked: () => Mpris.players[0].next()
        })
    ]
});
