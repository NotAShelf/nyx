import { Widget, Battery } from '../../imports.js';
const { Box, Label } = Widget;

const BatIcon = () =>
    Label({
        className: 'batIcon',
        connections: [
            [
                Battery,
                icon => {
                    icon.toggleClassName('charging', Battery.charging);
                    icon.toggleClassName('charged', Battery.charged);
                    icon.toggleClassName('low', Battery.percent < 30);
                },
                self => {
                    const icons = [
                        ['󰂎', '󰁺', '󰁻', '󰁼', '󰁽', '󰁾', '󰁿', '󰂀', '󰂁', '󰂂', '󰁹'],
                        ['󰢟', '󰢜', '󰂆', '󰂇', '󰂈', '󰢝', '󰂉', '󰢞', '󰂊', '󰂋', '󰂅'],
                    ];

                    const chargingIndex = Battery.charging ? 1 : 0;
                    const percentIndex = Math.floor(Battery.percent / 10);

                    self.label = icons[chargingIndex][percentIndex].toString();
                    self.tooltipText = `${Math.floor(Battery.percent)}%`;
                },
            ],
        ],
    });

export const BatteryWidget = () =>
    Box({
        className: 'battery',
        cursor: 'pointer',
        child: BatIcon(),
        binds: [['visible', Battery, 'available']],
    });
