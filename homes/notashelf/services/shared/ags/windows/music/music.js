import { Widget, App, Mpris } from '../../imports.js';
const { Window, Box, Label } = Widget;
import PopupWindow from '../../utils/popupWindow.js';
import { uwustagramControls } from './musicControls.js';

const truncateString = (str, maxLength) => (str.length > maxLength ? `${str.slice(0, maxLength)}...` : str);

const uwustagramArtist = () => Box({
    className: 'uwustagramArtist',
    children: [
        Label({
            className: 'artistIcon',
            label: '󰀉'
        }),
        Label({
            className: 'artist',
            label: 'N/A',
            useMarkup: true,
            connections: [[Mpris, self => {
                const player = Mpris.players[0];
                if (!player)
                    return;

                self.label = `${truncateString(`${player.trackArtists.join(', ')}`, 24)}`;
            }]]
        })
    ]
});

const uwustagramCover = () => Widget.Overlay({
    child: Box({
        className: 'uwustagramCover',
        connections: [[Mpris, self => {
            const player = Mpris.players[0];
            if (!player)
                return;

            self.css = `background-image: url('${player.coverPath}');`
        }]]
    }),
    overlays: [
        Box({
            className: 'uwustagramCoverOverlay',
            connections: [[Mpris, self => {
                const player = Mpris.players[0];
                if (!player)
                return;

                self.css = `background-image: url('${player.coverPath}');`
            }]]
        })
    ]
});

const uwustagramTitle = () => Label({
    className: 'uwustagramTitle',
    label: 'N/A',
    justification: 'center',
    connections: [[1000, self => {
        const player = Mpris.players[0];
        if (!player)
            return;

        self.label = `${truncateString(`${player.trackTitle}`, 24)}`;
    }]]
});

const uwustagramProgress = () => Widget.ProgressBar({
    className: 'uwustagramProgress',
    connections: [[1000, self => {
        const player = Mpris.players[0];
        if (!player)
            return;

        self.value = 0.5 /*player.position / player.length*/;
    }]]
})

Mpris.connect('player-closed', () => App.closeWindow('music'));

export const Music = ({ monitor } = {}) => PopupWindow({
    name: 'music',
    anchor: ['right'],
    layer: 'overlay',
    margins: [0, 24, 0, 0],
    transition: 'slide_left',
    popup: true,
    child: Box({
        className: 'music',
        vertical: true,
        children: [
            Label({
                className: 'uwustagramHeader',
                label: '<i>uwustagram</i>',
                justification: 'center',
                useMarkup: true
            }),
            uwustagramArtist(),
            uwustagramCover(),
            Label({
                className: 'uwustagramButtons',
                label: '󰣐  󰭹  󰒊',
                hpack: 'start'
            }),
            uwustagramTitle(),
            uwustagramProgress(),
            uwustagramControls()
        ]
    }),
});
