import { Utils, Widget, Variable } from "../../imports.js";
const { execAsync } = Utils;
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
                            if (v > 0) {
                                if ((v = 100)) return "cpuCritical";

                                if (v > 75) return "cpuHigh";

                                if (v > 35) return "cpuMod";

                                if (v > 15) return "bluetooth-paired";
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
