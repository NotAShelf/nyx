import { Bluetooth } from "../imports";
import Icons from "./icons";

export const getBluetoothDevice = (addr) =>
	Bluetooth.getDevice(addr).alias ?? Bluetooth.getDevice(addr).name;

export const getBluetoothIcon = (connected) => {
	if (!Bluetooth.enabled) return Icons.bluetooth.disabled;
	if (connected.length > 0) return Icons.bluetooth.active;
	return Icons.bluetooth.disconnected;
};

export const getBluetoothTooltip = (connected) => {
	if (!Bluetooth.enabled) return "Bluetooth off";

	if (connected.length > 0) {
		const dev = Bluetooth.getDevice(connected[0].address);
		let battery_str = "";

		if (dev.battery_percentage > 0) {
			battery_str += ` ${dev.battery_percentage}%`;
		}

		return dev.name + battery_str;
	}

	return "Bluetooth on";
};

export const getBluetoothClass = (connected) => {
	if (!Bluetooth.enabled) return "bluetooth-disabled";

	if (connected.length > 0) {
		const dev = Bluetooth.getDevice(connected.at(0).address);

		if (dev.battery_percentage <= 25) return "bluetooth-active-low-battery";

		if (dev.battery_percentage > 25) return "bluetooth-paired";
	}

	return "bluetooth-active";
};

export const getBluetoothLabel = (connected) => {
	if (!Bluetooth.enabled) return "󰂲";

	if (connected.length > 0) {
		const dev = Bluetooth.getDevice(connected.at(0).address);

		if (dev.battery_percentage <= 25) return "󰥇";
	}

	return "󰂰";
};
