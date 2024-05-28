import { Variable } from "../imports";
import {
    getWeatherData,
    getCachedWeatherData,
    formatWeatherData,
} from "../variables/weather.js";

export const WeatherValue = Variable(
    {},
    {
        poll: [
            36000,
            async () => {
                let data = await getWeatherData();
                if (!data) {
                    console.error(
                        "Failed to fetch weather data, using cached data",
                    );
                    data = getCachedWeatherData();
                }
                return formatWeatherData(data);
            },
        ],
    },
);

export const getWeatherIcon = (value: { text: any }) => value.text || "...";
export const getWeatherTooltip = (value: { tooltip: any }) =>
    value.tooltip || "...";
