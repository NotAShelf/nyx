import { Widget, Utils } from '../../imports.js';
const { Button, Label } = Widget;

const swallowStatus = Utils.exec(
    'sh -c "$HOME/.config/ags/js/scripts/hyprctl_swallow query"',
);

export const Swallow = () =>
    Button({
        className: 'swallow',
        cursor: 'pointer',
        child: Label('󰊰'),
        onClicked: (button) => {
            Utils.exec('sh -c \'$HOME/.config/ags/js/scripts/hyprctl_swallow\''),
            (button.tooltip_markup = `Swallow: ${
                JSON.parse(swallowStatus).status
            }`);
        },
    });
