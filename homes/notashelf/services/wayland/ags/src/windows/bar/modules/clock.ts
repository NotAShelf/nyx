import { Widget, Utils } from "../../../imports";
const { exec, execAsync } = Utils;
const { Label, Box } = Widget;

const Time = () =>
	Label({
		className: "timeLabel",
		setup: (self) => {
			// the current quote syntax is the only one that works
			// eslint-disable-next-line quotes
			self.poll(1000, (self) => (self.label = exec('date "+%H%n%M"')));
			self.poll(1000, (self) =>
				execAsync(["date", "+%H%n%M"])
					.then((time) => (self.label = time))
					// eslint-disable-next-line no-undef
					.catch(print.error),
			);
		},
	});

export const Clock = () =>
	Box({
		className: "clock",
		vertical: true,
		children: [Time()],
	});
