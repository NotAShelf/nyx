import { Widget } from "../../imports";
const { Window, Box, CenterBox } = Widget;

// Widgets
import { LauncherIcon } from "./modules/launcher";
import { Workspaces } from "./modules/workspaces";
import { Tray } from "./modules/tray";
import { BatteryWidget } from "./modules/battery";
import { Clock } from "./modules/clock";
import { PowerMenu } from "./modules/power";
import { Swallow } from "./modules/swallow";
import { BluetoothWidget } from "./modules/bluetooth";
import { AudioWidget } from "./modules/audio";
import { NetworkWidget } from "./modules/network";
import { SystemUsage } from "./modules/system";
import { Weather } from "./modules/weather";

const Top = () =>
    Box({
        className: "barTop",
        vertical: true,
        vpack: "start",
        children: [LauncherIcon(), SystemUsage(), Weather()],
    });

const Center = () =>
    Box({
        className: "barCenter",
        vertical: true,
        children: [Workspaces()],
    });

const Bottom = () =>
    Box({
        className: "barBottom",
        vertical: true,
        vpack: "end",
        children: [
            Tray(),
            Box({
                className: "utilsBox",
                vertical: true,
                children: [
                    BluetoothWidget(),
                    AudioWidget(),
                    Swallow(),
                    BatteryWidget(),
                    NetworkWidget(),
                ],
            }),
            Clock(),
            PowerMenu(),
        ],
    });

const Bar = ({ monitor: number } = {}) =>
    Window({
        name: "bar",
        anchor: ["top", "bottom", "left"],
        exclusivity: "exclusive",
        layer: "top",
        margins: [8, 0, 8, 8],
        child: CenterBox({
            className: "bar",
            vertical: true,
            startWidget: Top(),
            centerWidget: Center(),
            endWidget: Bottom(),
        }),
    });

export default Bar;
