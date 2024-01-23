import { Variable, Widget } from "../../../imports.js";
const { Button, Revealer, Box, Label, CircularProgress } = Widget;

const getMemClass = (v) => {
    const val = v * 100;
    const className = [
        [100, "memCritical"],
        [75, "memHigh"],
        [35, "memMod"],
        [5, "memLow"],
        [0, "memIdle"],
        [-1, "memRevealer"],
    ].find(([threshold]) => threshold <= val)[1];

    return className;
};

const getCpuClass = (v) => {
    const val = v * 100;

    const className = [
        [100, "cpuCritical"],
        [75, "cpuHigh"],
        [35, "cpuMod"],
        [5, "cpuLow"],
        [0, "cpuIdle"],
        [-1, "cpuRevealer"],
    ].find(([threshold]) => threshold <= val)[1];

    return className;
};

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
 */
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
                    // binds: [["value", process]],
                    rounded: true,
                    inverted: false,
                    startAt: 0.27,
                }).bind("value", process),
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
            child: Label()
                .bind("label", cpu, "value", (v) => `${Math.floor(v * 100)}%`)
                .bind("className", cpu, "value", getCpuClass),
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
            child: Label()
                .bind("label", mem, "value", (v) => `${Math.floor(v * 100)}%`)
                .bind("className", cpu, "value", getMemClass),
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
