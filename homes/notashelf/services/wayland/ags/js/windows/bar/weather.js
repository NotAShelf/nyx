import { Widget } from "../../imports.js";
import {
    WeatherValue,
    getWeatherIcon,
    getWeatherTooltip,
} from "../../utils/weather.js";
const { Label } = Widget;

export const Weather = () =>
    Label({
        hexpand: false,
        vexpand: false,
        class_name: "weather",
        setup: (self) => {
            self.bind("label", WeatherValue, "value", getWeatherIcon);
            self.bind("tooltip-text", WeatherValue, "value", getWeatherTooltip);
        },
    });
