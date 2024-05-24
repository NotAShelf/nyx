import {
    getWeatherData,
    getCachedWeatherData,
    formatWeatherData,
} from "../variables/weather.js";
import { Variable, App } from "../imports.js";

export const WeatherValue = Variable(
    {},
    {
        poll: [
            36000,
            async () => {
                let data = await getWeatherData();
                if (!data) {
                    data = getCachedWeatherData();
                }
                return formatWeatherData(data);
            },
        ],
    },
);

export const getWeatherIcon = (value) => value.text || "...";
export const getWeatherTooltip = (value) => value.tooltip || "...";
