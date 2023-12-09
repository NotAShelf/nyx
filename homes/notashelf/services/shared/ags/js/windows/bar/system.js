import { Widget, Variable } from "../../imports.js";
const { Button, Revealer, Box, Label, CircularProgress } = Widget;

const divide = ([total, free]) => free / total;
const cpu = Variable(0, {
    poll: [
        2000,
        "top -b -n 1",
        (out) =>
            divide([
                100,
                out
                    .split("\n")
                    .find((line) => line.includes("Cpu(s)"))
                    .split(/\s+/)[1]
                    .replace(",", "."),
            ]),
    ],
});

const mem = Variable(0, {
    poll: [
        2000,
        "free",
        (out) =>
            divide(
                out
                    .split("\n")
                    .find((line) => line.includes("Mem:"))
                    .split(/\s+/)
                    .splice(1, 2),
            ),
    ],
});

/**
 * @param {string} name
 * @param {typeof cpu | typeof ram} process
 * @param {Array<any>} extraChildren
 * @param  {() => void} onPrimary
 **/
const systemWidget = (name, process, extraChildren = [], onPrimary) =>
    Button({
        className: name + "Button",
        onPrimaryClick: onPrimary,
        child: Box({
            className: name,
            vertical: true,
            children: [
                CircularProgress({
                    className: name + "Progress",
                    binds: [["value", process]],
                    rounded: true,
                    inverted: false,
                    startAt: 0.27,
                }),
                ...extraChildren,
            ],
        }),
    });

const CPU = systemWidget(
    "cpu",
    cpu,
    [
        Revealer({
            transition: "slide_down",
            child: Label({
                binds: [
                    ["label", cpu, "value", (v) => `${Math.floor(v * 100)}%`],
                    [
                        "className",
                        cpu,
                        "value",
                        (v) => {
                            let val = v * 100;
                            if (v > 0) {
                                if (val === 100) return "cpuCritical";

                                if (val > 75 && val < 100) return "cpuHigh";

                                if (val > 35 && val <= 75) return "cpuMod";

                                if (val > 5 && val <= 25) return "cpuLow";

                                if (val <= 5) return "cpuIdle";
                            }

                            return "cpuRevealer";
                        },
                    ],
                ],
            }),
            transition_duration: 250,
        }),
    ],
    (self) => {
        self.child.children[1].revealChild =
            !self.child.children[1].revealChild;
    },
);

const MEM = systemWidget(
    "mem",
    mem,
    [
        Revealer({
            transition: "slide_down",
            child: Label({
                binds: [
                    ["label", mem, "value", (v) => `${Math.floor(v * 100)}%`],
                    [
                        "className",
                        cpu,
                        "value",
                        (v) => {
                            let val = v * 100;
                            if (val > 0) {
                                if (val === 100) return "memCritical";

                                if (val > 75 && val < 100) return "memHigh";

                                if (val > 35 && val <= 75) return "memMod";

                                if (val > 5 && val <= 25) return "memLow";

                                if (val <= 5) return "memIdle";
                            }

                            return "memRevealer";
                        },
                    ],
                ],
            }),
            transition_duration: 250,
        }),
    ],
    (self) => {
        self.child.children[1].revealChild =
            !self.child.children[1].revealChild;
    },
);

export const SystemUsage = () =>
    Box({
        className: "systemUsage",
        vertical: true,
        cursor: "pointer",
        children: [CPU, MEM],
    });
