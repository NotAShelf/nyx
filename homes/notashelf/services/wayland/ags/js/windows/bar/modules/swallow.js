import { Widget } from "../../../imports.js";
const { Label, Button } = Widget;

import {
    toggleSwallowStatus,
    status,
} from "../../../utils/swallow.js";


export const Swallow = () => 
    Button({
        className: "swallow",
        cursor: "pointer",
        child: Label({
            label: "󰊰",
        }),
        tooltipText: `${status.value}`,
        onPrimaryClick: toggleSwallowStatus,
    }).hook(status, (self) => self.tooltipText = `${status.value}`);

