import { Battery } from "../imports";

/**
 * toTime converts a given value to a human-readable
 * format where the number of hours and minutes are
 * inferred from time, which is assumed to be in seconds.
 *
 * @param {number} time - time in seconds
 */
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
    const timeRemaining = Battery.timeRemaining;
    return timeRemaining > 0 && toTime(timeRemaining) != ""
        ? `${toTime(timeRemaining)}remaining`
        : "";
};

export const getBatteryPercentage = () => {
    const percent = Battery.percent;
    return percent > 0 && percent < 100 ? `${percent}%` : "";
};

export const getBatteryTooltip = () => {
    const time = getBatteryTime();
    const percent = Battery.percent;

    return `${percent}% | ${time}`;
};

export const getBatteryIcon = () => {
    // if Battery.percent is not between 0 and 100, handle the error
    if (Battery.percent < 0 || Battery.percent > 100)
        return "Battery percentage is not a valid value!";

    const icons = [
        ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
        ["󰢟", "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"],
    ];

    const chargingIndex = Battery.charging ? 1 : 0;
    const percentIndex = Math.floor(Battery.percent / 10);
    return icons[chargingIndex][percentIndex].toString();
};
