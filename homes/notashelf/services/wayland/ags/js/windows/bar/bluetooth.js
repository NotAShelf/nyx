import { Bluetooth, Widget, Utils } from "../../imports.js";
import {
    getBluetoothIcon,
    getBluetoothLabel,
    getBluetoothClass,
    getBluetoothTooltip,
} from "../../utils/bluetooth.js";
const { Button, Label } = Widget;

export const BluetoothModule = () =>
    Label({ className: "bluetoothIcon" })
        .bind("label", Bluetooth, "connected-devices", getBluetoothIcon)
        .bind(
            "tooltip-text",
            Bluetooth,
            "connected-devices",
            getBluetoothTooltip,
        )
        .bind("class", Bluetooth, "connected-devices", getBluetoothClass)
        .bind("label", Bluetooth, "connected-devices", getBluetoothLabel);

export const BluetoothWidget = () => {
    return Button({
        className: "bluetooth",
        cursor: "pointer",
        child: BluetoothModule(),
        visible: Bluetooth.connectedDevices.length > 0,
        onClicked: () => Utils.exec("blueman-applet"),
    });
};
