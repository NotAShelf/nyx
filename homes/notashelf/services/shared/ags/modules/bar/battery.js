import { Widget, Utils, Battery } from '../../imports.js';
const { Box, Label } = Widget;

const BatIcon = () => Label({
    className: 'batIcon',
    connections: [[Battery, self => {
        const icons = [
            ['󰂎', '󰁺', '󰁻', '󰁼', '󰁽', '󰁾', '󰁿', '󰂀', '󰂁', '󰂂', '󰁹'],
            ['󰢟', '󰢜', '󰂆', '󰂇', '󰂈', '󰢝', '󰂉', '󰢞', '󰂊', '󰂋', '󰂅']
        ];

        self.label = icons[(Battery.charging ? 1 : 0)][(Math.floor(Battery.percent / 10))].toString();
        //self.tooltipText = `${Math.floor(Battery.percent)}%`;
    }]]
});

export const BatteryWidget = () => Box({
    className: 'battery',
    child: BatIcon()
});