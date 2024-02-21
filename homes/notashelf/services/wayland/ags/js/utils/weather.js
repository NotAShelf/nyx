import { Variable, App } from "../imports.js";

export const WeatherValue = Variable(
    {},
    {
        poll: [
            36000,
            ["sh", "-c", `python ${App.configDir}/bin/weather`],
            (out) => JSON.parse(out),
        ],
    },
);

export const getWeatherIcon = (value) => value.text || "...";
export const getWeatherTooltip = (value) => value.tooltip || "...";
