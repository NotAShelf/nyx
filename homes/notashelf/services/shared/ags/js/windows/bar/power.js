import { Widget } from "../../imports.js";
const { Button, Label } = Widget;

export const PowerMenu = () =>
    Button({
        className: "power",
        cursor: "pointer",
        child: Label(""),
    });
