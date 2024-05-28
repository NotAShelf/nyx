import { Widget, Utils } from "../../../imports";
import Brightness from "../../../services/brightness";
const { Box, Slider, Label, Revealer } = Widget;

const BrightnessIcon = () =>
	Label({
		className: "brtPopupIcon",
		setup: (self) => {
			self.hook(Brightness, (self) => {
				const icons = ["", "", "", "", "", "", "", "", ""];

				let index = Math.floor((Brightness.screen * 100) / 11);
				index = Math.max(0, Math.min(index, icons.length - 1));

				if (index >= 0 && index < icons.length) {
					self.label = icons[index].toString();
				} else {
					console.log("Index out of bounds:", index);
				}
			});
		},
	});

const PercentBar = () =>
	Slider({
		className: "brtPopupBar",
		drawValue: false,
		onChange: ({ value }) => (Brightness.screen = value),
		setup: (self) => {
			self.hook(Brightness, (self) => (self.value = Brightness.screen));
		},
	});

export const BrightnessPopup = () =>
	Box({
		css: `min-height: 1px;
          min-width: 1px;`,
		child: Revealer({
			transition: "slide_up",
			child: Box({
				className: "brightnessPopup",
				children: [BrightnessIcon(), PercentBar()],
			}),
			attribute: { count: 0 },
			setup: (self) => {
				self.hook(Brightness, (self) => {
					self.revealChild = true;
					self.attribute.count++;
					Utils.timeout(1500, () => {
						self.attribute.count--;

						if (self.attribute.count === 0)
							self.revealChild = false;
					});
				});
			},
		}),
	});
