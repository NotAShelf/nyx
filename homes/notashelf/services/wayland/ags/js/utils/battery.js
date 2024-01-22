import { Battery } from "../imports.js";

export const toTime = (time) => {
    const MINUTE = 60;
    const HOUR = MINUTE * 60;

    if (time > 24 * HOUR) return "";

    const hours = Math.round(time / HOUR);
    const minutes = Math.round((time - hours * HOUR) / MINUTE);

    const hoursDisplay = hours > 0 ? `${hours}h ` : "";
    const minutesDisplay = minutes > 0 ? `${minutes}m ` : "";

    return `${hoursDisplay}${minutesDisplay}`;
};

export const getBatteryTime = () => {
    return Battery.timeRemaining > 0 && toTime(Battery.timeRemaining) != ""
        ? `${toTime(Battery.timeRemaining)}remaining`
        : "";
};

export const getBatteryIcon = () => {
    const icons = [
        ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
        ["󰢟", "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"],
    ];

    const chargingIndex = Battery.charging ? 1 : 0;
    const percentIndex = Math.floor(Battery.percent / 10);
    return icons[chargingIndex][percentIndex].toString();
};
