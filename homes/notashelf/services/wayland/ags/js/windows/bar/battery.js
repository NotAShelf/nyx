import { Widget, Utils, Battery } from "../../imports.js";
const { Box, Label, Revealer } = Widget;

const BatIcon = () =>
    Label({
        className: "batIcon",
        setup: (self) => {
            self.hook(Battery, (self) => {
                const icons = [
                    ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
                    ["󰢟", "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"],
                ];

                const chargingIndex = Battery.charging ? 1 : 0;
                const percentIndex = Math.floor(Battery.percent / 10);
                self.label = icons[chargingIndex][percentIndex].toString();
                self.tooltipText = `${Math.floor(Battery.percent)}%`;
            });
        },
    });

const PercentLabel = () =>
    Revealer({
        transition: "slide_down",
        revealChild: false,
        child: Label({
            className: "batPercent",
            connections: [
                [
                    Battery,
                    (self) => {
                        self.label = `${Battery.percent}%`;
                    },
                ],
            ],
        }),
    });

export const BatteryWidget = () =>
    Box({
        className: "battery",
        cursor: "pointer",
        child: BatIcon(),
        binds: [["visible", Battery, "available"]],
    });
