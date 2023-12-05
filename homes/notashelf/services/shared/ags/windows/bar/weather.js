import { Widget, Utils } from "../../imports.js";
import { Icon } from "../../icons.js";

const { Box, Label } = Widget;

/** @type {number} */
const thirtyMinutes = 1000 * 60 * 30;

const twelveToTwentyFour = (/** @type {string} */ s) => {
	const time = s.split(" ");
	const [hoursStr, minutesStr] = time[0].split(":");
	let hours = Number(hoursStr);
	const minutes = Number(minutesStr);
	const ampm = time[1].toUpperCase();

	if (ampm === "PM" && hours < 12) {
		hours += 12;
	}
	if (ampm === "AM" && hours === 12) {
		hours = 0;
	}
	return (
		hours.toString().padStart(2, "0") +
		":" +
		minutes.toString().padStart(2, "0")
	);
};

const isDayTime = (
	/** @type {Date} */ sunset,
	/** @type {Date} */ sunrise,
	/** @type {Date} */ now,
) => {
	const ret =
		sunset.getTime() > now.getTime() && now.getTime() > sunrise.getTime();
	return ret;
};

export const Weather = () =>
	Box({
		class_name: "weather",
		has_tooltip: true,
		children: [
			Label({
				class_name: "weather-icon",
			}),
			Label({
				class_name: "weather-temp",
			}),
		],
		connections: [
			[
				thirtyMinutes,
				(self) => {
					Utils.fetch("http://wttr.in/?format=j1")
						.then((res) => {
							const weather = JSON.parse(res);
							const weatherCondition =
								weather["current_condition"][0];

							const currentTime = twelveToTwentyFour(
								weatherCondition["localObsDateTime"].substring(
									11,
								),
							);
							const sunSetDate = weather["weather"][0]["date"];
							let sunRiseDate = weather["weather"][0]["date"];
							sunRiseDate = sunRiseDate.split("-");
							sunRiseDate = `${sunRiseDate[0]}-${
								sunRiseDate[1]
							}-${Number(sunRiseDate[2]) + 1}`;
							const sunSet = twelveToTwentyFour(
								weather["weather"][0]["astronomy"][0]["sunset"],
							);
							const sunRise = twelveToTwentyFour(
								weather["weather"][0]["astronomy"][0][
									"sunrise"
								],
							);
							const sunset = new Date(`${sunSetDate}T${sunSet}`);
							const sunrise = new Date(
								`${sunRiseDate}T${sunRise}`,
							);
							const current = new Date(
								`${sunSetDate}T${currentTime}`,
							);

							const isDay = isDayTime(sunset, sunrise, current);

							/** @type {string} */
							let icon =
								Icon.weather[weatherCondition["weatherCode"]];
							const night = Icon.weather[icon];
							icon = isDay ? icon : night ?? icon;

							/** @type {string} */
							const temp = weatherCondition["temp_C"];
							self.children[0]["label"] = icon;
							self.children[1]["label"] = `${temp.replaceAll(
								"+",
								"",
							)}°C`;

							const location = weather["nearest_area"][0];
							const city = location["areaName"][0]["value"];
							const country = location["country"][0]["value"];
							self.tooltip_markup =
								`Location: ${city}, ${country}` +
								"\n" +
								`FeelsLike: ${weatherCondition[
									"FeelsLikeC"
								].replaceAll("+", "")}°C` +
								"\n" +
								`Humidity: ${weatherCondition["humidity"]}%` +
								"\n" +
								`Weather: ${weatherCondition["weatherDesc"][0]["value"]}`;
						})
						.catch((err) => console.error(err));
				},
			],
		],
	});
