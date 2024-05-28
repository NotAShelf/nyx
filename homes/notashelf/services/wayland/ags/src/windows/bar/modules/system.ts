import { Variable, Widget } from "../../../imports";
import { getCpuClass } from "../../../utils/system";
import { getMemClass } from "../../../utils/system";
const { Button, Revealer, Box, Label, CircularProgress } = Widget;

const divide = ([total, free]) => free / total;

const cpu = Variable(0, {
    poll: [
        3000,
        "top -b -n 1",
        (out) => {
            const match = out.match(/Cpu\(s\):\s*([\d.]+)\s*us/);
            if (match) {
                return divide([100, match[1]]);
            }
            return 0;
        },
    ],
});

const mem = Variable(0, {
    poll: [
        3000,
        "free",
        (out) => {
            const match = out.match(/Mem:\s+(\d+)\s+(\d+)/);
            if (match) {
                return divide([match[1], match[2]]);
            }
            return 0;
        },
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
        className: `${name}Button`,
        onPrimaryClick: onPrimary,
        child: Box({
            className: name,
            vertical: true,
            children: [
                CircularProgress({
                    className: `${name}Progress`,
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
        const revealer = self.child.children[1];
        revealer.revealChild = !revealer.revealChild;
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
                .bind("className", mem, "value", getMemClass),
            transition_duration: 250,
        }),
    ],
    (self) => {
        const revealer = self.child.children[1];
        revealer.revealChild = !revealer.revealChild;
    },
);

export const SystemUsage = () =>
    Box({
        className: "systemUsage",
        vertical: true,
        cursor: "pointer",
        children: [CPU, MEM],
    });
