import { Widget } from "../../../imports.js";
const { Label, Button } = Widget;

import {
    getSwallowStatus,
    toggleSwallowStatus,
} from "../../../utils/swallow.js";

const keyword = getSwallowStatus();

export const Swallow = () => {
    Button({
        className: "swallow",
        cursor: "pointer",
        onPrimaryClick: toggleSwallowStatus(keyword),
        child: Label({
            label: "󰊰",
        }),
    });
};
