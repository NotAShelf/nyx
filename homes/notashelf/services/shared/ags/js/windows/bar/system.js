import { Utils, Widget } from "../../imports.js";
const { execAsync } = Utils;
const { Box, Label, CircularProgress, Button } = Widget;

const label = Label({
    className: "cpu-inner",
    label: "",
});

const progress = CircularProgress({
    className: "cpu",
    child: Button({
        className: "unset no-hover",
        onClicked: () => showHardwareMenu(),
        child: label,
    }),
    startAt: 0,
    rounded: false,
    // inverted: true,
});

const CpuWidget = () =>
    Box({
        className: "bar-hw-cpu-box",
        connections: [
            [
                1000,
                (box) => {
                    execAsync(
                        `/home/${Utils.USER}/.config/ags/js/scripts/get_cpu`,
                    )
                        .then((val) => {
                            progress.value = val / 100;
                            label.tooltipMarkup = `<span weight='bold' foreground='#FDC227'>CPU (${val}%)</span>`;
                        })
                        .catch(print);
                    box.children = [progress];
                    box.show_all();
                },
            ],
        ],
    });

const cpu = () =>
    Box({
        vertical: true,
        children: [
            Label({
                className: "processor",
                label: "",
                connections: [
                    [
                        2000,
                        (self) =>
                            execAsync([
                                "sh",
                                "-c",
                                "top -bn1 | rg '%Cpu' | tail -1 | awk '{print 100-$8}'",
                            ])
                                .then(
                                    (r) =>
                                        (self.tooltipText =
                                            Math.round(Number(r)) + "%"),
                                )
                                .catch((err) => print(err)),
                    ],
                ],
                binds: [
                    [
                        "className",
                        (self) =>
                            execAsync([
                                "sh",
                                "-c",
                                "top -bn1 | rg '%Cpu' | tail -1 | awk '{print 100-$8}'",
                            ])
                                .then(
                                    (r) =>
                                        (self.tooltipText =
                                            Math.round(Number(r)) + "%"),
                                )
                                .catch((err) => print(err)),
                    ],
                ],
            }),
        ],
    });

const memory = () =>
    Box({
        vertical: true,
        children: [
            Label({
                className: "memory",
                label: "",
                connections: [
                    [
                        2000,
                        (self) =>
                            execAsync([
                                "sh",
                                "-c",
                                "free | tail -2 | head -1 | awk '{print $3/$2*100}'",
                            ])
                                .then(
                                    (r) =>
                                        (self.label =
                                            Math.round(Number(r)) + "%"),
                                )
                                .catch((err) => print(err)),
                    ],
                ],
                binds: [
                    [
                        "className",
                        (self) =>
                            execAsync([
                                "sh",
                                "-c",
                                "top -bn1 | rg '%Cpu' | tail -1 | awk '{print 100-$8}'",
                            ])
                                .then(
                                    (r) =>
                                        (self.tooltipText =
                                            Math.round(Number(r)) + "%"),
                                )
                                .catch((err) => print(err)),
                    ],
                ],
            }),
        ],
    });

export const SystemInfo = () =>
    Box({
        className: "systemInfo",
        vertical: true,
        cursor: "pointer",
        children: [CpuWidget()],
    });
