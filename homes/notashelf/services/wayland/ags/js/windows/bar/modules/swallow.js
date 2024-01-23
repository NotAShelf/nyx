import { Widget, Utils } from "../../../imports.js";
const { Button, Label } = Widget;

const swallowStatus = Utils.exec(
    // eslint-disable-next-line quotes
    'sh -c "$HOME/.config/ags/js/scripts/hyprctl_swallow query"',
);

export const Swallow = () =>
    Button({
        className: "swallow",
        cursor: "pointer",
        child: Label("󰊰"),
        onClicked: (button) => {
            button.tooltip_markup = `Swallow: ${
                JSON.parse(swallowStatus).status
            }`;
        },
    });
