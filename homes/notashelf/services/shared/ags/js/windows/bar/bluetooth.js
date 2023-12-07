import { Bluetooth, Widget, Utils } from "../../imports.js";
const { Button, Label } = Widget;

export const BluetoothModule = () =>
    Label({
        connections: [
            [
                Bluetooth,
                (self) => {
                    self.children = Bluetooth.connectedDevices.map(
                        ({ iconName, name }) =>
                            Label({
                                indicator: Widget.Icon(iconName + "-symbolic"),
                                child: Widget.Label(name),
                            }),
                    );
                },
                "notify::connected-devices",
            ],
        ],

        binds: [
            [
                "tooltip-text",
                Bluetooth,
                "connected-devices",
                (connected) => {
                    if (!Bluetooth.enabled) return "Bluetooth off";

                    if (connected.length > 0) {
                        const dev = Bluetooth.getDevice(
                            connected.at(0).address,
                        );
                        let battery_str = "";

                        if (dev.battery_percentage > 0)
                            battery_str += " " + dev.battery_percentage + "%";

                        return dev.name + battery_str;
                    }

                    return "Bluetooth on";
                },
            ],
            [
                "className",
                Bluetooth,
                "connected-devices",
                (connected) => {
                    if (!Bluetooth.enabled) return "bluetooth-disabled";

                    if (connected.length > 0) {
                        const dev = Bluetooth.getDevice(
                            connected.at(0).address,
                        );

                        if (dev.battery_percentage <= 25)
                            return "bluetooth-active-low-battery";

                        if (dev.battery_percentage > 25)
                            return "bluetooth-paired";
                    }

                    return "bluetooth-active";
                },
            ],
            [
                "label",
                Bluetooth,
                "connected-devices",
                (connected) => {
                    if (!Bluetooth.enabled) return "󰂲";

                    if (connected.length > 0) {
                        const dev = Bluetooth.getDevice(
                            connected.at(0).address,
                        );

                        if (dev.battery_percentage <= 25) return "󰥇";
                    }

                    return "󰂰";
                },
            ],
        ],
    });

export const BluetoothWidget = () => {
    return Button({
        className: "bluetooth",
        cursor: "pointer",
        child: BluetoothModule(),
        visible: Bluetooth.connectedDevices.length > 0,
        onClicked: () => Utils.exec("blueman-applet"),
    });
};
