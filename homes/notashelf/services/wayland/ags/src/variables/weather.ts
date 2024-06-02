import { Utils, GLib, Gio } from "../imports";

const { get_user_cache_dir, get_home_dir, build_filenamev } = GLib;
const { fetch } = Utils;
const fs = Gio;

const CACHE_EXPIRATION = 60; // minutes
const XDG_CACHE_HOME = get_user_cache_dir() || get_home_dir() + "/.cache";
const CACHE_DIR_PATH = build_filenamev([XDG_CACHE_HOME, "zephyr"]);
const CACHE_DIR = fs.File.new_for_path(CACHE_DIR_PATH);
const CACHE_FILE_PATH = build_filenamev([CACHE_DIR_PATH, "zephyr_cache.json"]);
const CACHE_FILE = fs.File.new_for_path(CACHE_FILE_PATH);

const SUNNY = "\udb81\udda8";
const CLOUDY = "\ue312";
const RAIN = "\ue318";
const SNOW = "\ue31a";
const THUNDERSTORM = "\ue31d";
const PARTLY_CLOUDY = "\ue302";
const CLEAR = "\udb81\udda8";

const HOURS_AGO_THRESHOLD = 2;
const TEMP_THRESHOLD_COLD = 10;
const TEMP_THRESHOLD_HOT = 0;

const ensureCacheDirectory = () => {
    try {
        if (!fs.File.new_for_path(CACHE_DIR).query_exists(null)) {
            fs.File.new_for_path(CACHE_DIR).make_directory_with_parents(null);
        }
    } catch (e) {
        console.error(`Error creating cache directory: ${e}`);
    }
};

export const getWeatherData = (): Promise<any> => {
    return new Promise((resolve, reject) => {
        fetch("http://wttr.in/?format=j1")
            .then((res: any) => res.text())
            .then((text: string) => {
                try {
                    const data = JSON.parse(text);
                    resolve(data);
                } catch (error) {
                    console.error(error);
                    // provide dummy data to avoid errors
                    resolve({ text: "Dummy data" });
                }
            })
            .catch(reject);
    });
};

export const cacheWeatherData = (data: any): void => {
    try {
        ensureCacheDirectory();
        const cachedData = {
            data,
            timestamp: new Date().toISOString(),
        };
        const outputStream = CACHE_FILE.replace(
            null,
            false,
            Gio.FileCreateFlags.NONE,
            null,
        );
        const text = `${cachedData.timestamp}\n${JSON.stringify(cachedData.data)}`;
        outputStream.write(text, null);
        outputStream.close(null);
    } catch (e) {
        console.error(`Error caching data: ${e}`);
    }
};

export const getCachedWeatherData = (): any | null => {
    try {
        if (CACHE_FILE.query_exists(null)) {
            const inputStream = CACHE_FILE.read(null);
            const [, content] = inputStream.read();
            inputStream.close(null);
            const [timestamp, jsonData] = content.toString().split("\n");
            const cacheTime = new Date(timestamp);
            if ((new Date() - cacheTime) / 60000 < CACHE_EXPIRATION) {
                return JSON.parse(jsonData);
            }
        }
    } catch (e) {
        console.error(`Error loading cached data: ${e}`);
    }
    return null;
};

const formatTime = (time: string): string =>
    time.replace("00", "").padStart(2, "0");

const formatTemp = (temp: number): string => ` ${temp}°`.padEnd(4, " ");

const getEmojiForCondition = (condition: string): string => {
    const emojiMap: { [key: string]: string } = {
        Sunny: SUNNY,
        "Partly cloudy": PARTLY_CLOUDY,
        Overcast: CLOUDY,
        "Patchy rain nearby": RAIN,
        Clear: CLEAR,
        Fog: "\ue313",
        Frost: "\udb83\udf29",
        Thunder: THUNDERSTORM,
        Snow: SNOW,
        Windy: "\u27A7",
        Mist: "\u2601",
        Drizzle: "\u2601",
        "Heavy rain": "\u2614",
        Sleet: "\u2744",
        "Wintry mix": "\u2744",
        "Clear/Sunny": CLEAR,
        "Clear/Mostly clear": CLEAR,
        "Clear/Mostly clear (night)": CLEAR,
        "Drizzle (night)": "\u2601",
    };
    return emojiMap[condition] || "";
};

const formatConditions = (hour: any): string => {
    const conditionProbabilities: { [key: string]: string } = {
        chanceoffog: "Fog",
        chanceoffrost: "Frost",
        chanceofovercast: "Overcast",
        chanceofrain: "Rain",
        chanceofsnow: "Snow",
        chanceofsunshine: "Sunshine",
        chanceofthunder: "Thunder",
        chanceofwindy: "Wind",
    };
    if (hour.chanceofpartlycloudy) {
        conditionProbabilities["chanceofpartlycloudy"] = "Partly Cloudy";
    }
    const conditions: string[] = [];
    for (const [event, description] of Object.entries(conditionProbabilities)) {
        if (hour[event]) {
            const probability = parseInt(hour[event]);
            if (probability > 0) {
                const emoji = getEmojiForCondition(description);
                conditions.push(`${emoji} ${description} ${probability}%`);
            }
        }
    }
    return conditions.join(", ");
};

export const formatWeatherData = (
    weatherData: any,
): { text: string; tooltip: string } => {
    const formattedData = {
        text: "",
        tooltip: "",
    };

    if (!weatherData || !weatherData.current_condition) {
        // weather data or current condition is missing, return default data
        formattedData.tooltip = "No weather data available";
        return formattedData;
    }

    const currentCondition = weatherData.current_condition[0];
    const temp = parseInt(currentCondition.FeelsLikeC);
    const tempSign =
        TEMP_THRESHOLD_HOT > temp && temp > TEMP_THRESHOLD_COLD ? "+" : "";
    formattedData.text = ` ${SUNNY} \n ${tempSign}${temp}°`;
    formattedData.tooltip =
        `${currentCondition.weatherDesc[0].value} ${currentCondition.temp_C}°\n` +
        `Feels like: ${currentCondition.FeelsLikeC}°\n` +
        `Wind: ${currentCondition.windspeedKmph}Km/h\n` +
        `Humidity: ${currentCondition.humidity}%\n`;

    if (!weatherData.weather || weatherData.weather.length === 0) {
        // weather array is missing or empty, return default data
        formattedData.tooltip += "No weather forecast available";
        return formattedData;
    }

    weatherData.weather.forEach((day: any, i: number) => {
        formattedData.tooltip += "\n";
        if (i === 0) formattedData.tooltip += "Today, ";
        if (i === 1) formattedData.tooltip += "Tomorrow, ";
        formattedData.tooltip += `${day.date}\n`;
        formattedData.tooltip += `⬆️ ${day.maxtempC}° ⬇️ ${day.mintempC}° `;
        formattedData.tooltip += `🌅 ${day.astronomy[0].sunrise} 🌇 ${day.astronomy[0].sunset}\n`;
        const now = new Date();
        if (!day.hourly || day.hourly.length === 0) {
            // hourly data is missing or empty, continue to the next day
            formattedData.tooltip +=
                "No hourly forecast available for this day\n";
            return;
        }
        day.hourly.forEach((hour: any) => {
            const hourTime = formatTime(hour.time);
            if (
                i === 0 &&
                parseInt(hourTime) < now.getHours() - HOURS_AGO_THRESHOLD
            ) {
                return;
            }
            formattedData.tooltip += `${hourTime} ${getEmojiForCondition(hour.weatherDesc[0].value)} ${formatTemp(hour.FeelsLikeC)} ${hour.weatherDesc[0].value}, ${formatConditions(hour)}\n`;
        });
    });

    return formattedData;
};
