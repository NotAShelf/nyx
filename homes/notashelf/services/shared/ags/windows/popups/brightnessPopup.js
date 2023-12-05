import { Widget, Utils, App } from '../../imports.js';
import Brightness from '../../services/brightness.js';
const { Box, Slider, Label } = Widget;

const BrightnessIcon = () => Label({
    className: 'brtPopupIcon',
    connections: [[Brightness, self => {
        const icons = ['󰃚', '󰃛', '󰃜', '󰃝', '󰃞', '󰃟', '󰃠'];

        self.label = icons[(Math.floor((Brightness.screen * 100) / 14))].toString();
    }]]
});


const PercentLabel = () => Label({
    className: 'brtPopupLabel',
    label: 'Brightness',
    connections: [[Brightness, self => self.label = `Brightness • ${Math.floor(Brightness.screen * 100)}`]]
})

const PercentBar = () => Slider({
    className: 'brtPopupBar',
    drawValue: false,
    onChange: ({ value }) => Brightness.screen = value,
    connections: [[Brightness, self => self.value = Brightness.screen]],
});

export const BrightnessPopup = () => Box({
    css: `min-height: 1px;
          min-width: 1px;`,
    child: Widget.Revealer({
        transition: 'slide_up',
        child: Box({
            className: 'brightnessPopup',
            vertical: true,
            children: [
                PercentLabel(),
                PercentBar()
            ]
        }),
        properties: [['count', 0]],
        connections: [[Brightness, self => {
            self.revealChild = true;
            self._count++;
            Utils.timeout(1500, () => {
                self._count--;

                if (self._count === 0)
                    self.revealChild = false;
            })
        }]]
    })
});
