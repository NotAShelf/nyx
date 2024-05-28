import { Bluetooth, Widget, Utils } from "../../../imports";
import {
	getBluetoothIcon,
	getBluetoothLabel,
	getBluetoothClass,
	getBluetoothTooltip,
} from "../../../utils/bluetooth.js";
const { Button, Label } = Widget;

const BluetoothModule = () =>
	Label({ className: "bluetoothIcon" })
		.bind("label", Bluetooth, "connected-devices", getBluetoothIcon)
		.bind("class", Bluetooth, "connected-devices", getBluetoothClass)
		.bind("label", Bluetooth, "connected-devices", getBluetoothLabel)
		.bind(
			"tooltip-text",
			Bluetooth,
			"connected-devices",
			getBluetoothTooltip,
		);

export const BluetoothWidget = () =>
	Button({
		className: "bluetooth",
		cursor: "pointer",
		child: BluetoothModule(),
		visible: Bluetooth.connectedDevices.length > 0,
		onClicked: () => Utils.exec("blueman-applet"),
	});
