import { Widget } from "../../../imports.js";
import {
    WeatherValue,
    getWeatherIcon,
    getWeatherTooltip,
} from "../../../utils/weather.js";
const { Label } = Widget;

const weatherWidget = () =>
    Label({
        hexpand: false,
        vexpand: false,
        class_name: "weather",
        setup: (self) => {
            self.bind("label", WeatherValue, "value", getWeatherIcon);
            self.bind("tooltip-text", WeatherValue, "value", getWeatherTooltip);
        },
    });

export const Weather = () =>
    Widget.CenterBox({
        vertical: true,
        centerWidget: weatherWidget(),
    });
