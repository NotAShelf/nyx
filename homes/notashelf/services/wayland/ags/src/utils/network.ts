import { Network } from "../imports";

import Icons from "./icons";
const { wifi, wired } = Icons;

export const getWifiIcon = (strength) => {
    if (strength < 0.1) return wifi.none;
    if (strength < 0.26) return wifi.bad;
    if (strength < 0.51) return wifi.low;
    if (strength < 0.76) return wifi.normal;
    if (strength > 0.76) return wifi.good;
    else return wifi.none;
};

export const getWifiTooltip = (strength, ssid) => {
    const wifi = Network.wifi;
    const wifiStrength = `Strength: ${strength * 100}`;

    switch (wifi.internet) {
        case "connected":
            return `Connected to ${ssid} | Strength: ${wifiStrength}`;
        case "connecting":
            return `Connecting to ${ssid} | Strength: ${wifiStrength}`;
        case "disconnected":
            return `Disconnected from ${ssid} | Strength: ${wifiStrength}`;
        default:
            return `No connection | Strength: ${wifiStrength}`;
    }
};

export const getWiredIcon = (internet) => {
    if (internet === "connected") return wired.power;
    if (internet === "connecting") return wired.poweroff;
    if (internet === "disconnected") return wired.poweroff;
    return wired.poweroff;
};

export const getWiredTooltip = (internet) => {
    return `Status: ${internet}`;
};
