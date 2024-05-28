import { Widget, Utils, Audio } from "../../../imports.js";
import { getSliderIcon, volumePercentBar } from "../../../utils/audio";
const { Box, Revealer } = Widget;
const { speaker } = Audio;
const { timeout } = Utils;

export const VolumePopup = () =>
	Box({
		css: `
        min-height: 2px;
        min-width: 2px;
    `,
		child: Revealer({
			transition: "slide_up",
			child: Box({
				className: "volumePopup",
				children: [getSliderIcon(), volumePercentBar()],
			}),
			attribute: { count: 0 },
			setup: (self) =>
				self.hook(
					speaker,
					() => {
						self.reveal_child = true;
						self.attribute.count++;
						timeout(1500, () => {
							self.attribute.count--;

							if (self.attribute.count === 0)
								self.reveal_child = false;
						});
					},
					"notify::volume",
				),
		}),
	});
