import { Widget, Variable, App } from "../../imports.js";

const weather = Variable(
    {},
    {
        poll: [
            36000,
            `python ${App.configDir}/js/scripts/weather`,
            (out) => JSON.parse(out),
        ],
    },
);

export const Weather = () =>
    Widget.Label({
        hexpand: false,
        class_name: "weather",
        binds: [
            ["label", weather, "value", (value) => value.text || "..."],
            [
                "tooltip-text",
                weather,
                "value",
                (value) => value.tooltip || "...",
            ],
        ],
    });
