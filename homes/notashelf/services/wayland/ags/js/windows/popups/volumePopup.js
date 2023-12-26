import { Widget, Utils, Audio } from "../../imports.js";
const { Box, Slider, Label } = Widget;

const VolumeIcon = () =>
    Label({
        className: "volPopupIcon",
        setup: (self) => {
            self.hook(
                Audio,
                (self) => {
                    if (!Audio.speaker) return;

                    const icons = ["󰝟", "󰕿", "󰖀", "󰕾"];

                    self.label =
                        icons[
                            Audio.speaker.stream.isMuted
                                ? 0
                                : Math.floor((Audio.speaker.volume * 100) / 26)
                        ].toString();
                },
                "speaker-changed",
            );
        },
    });

const PercentBar = () =>
    Slider({
        className: "volPopupBar",
        drawValue: false,
        onChange: ({ value }) => (Audio.speaker.volume = value),
        setup: (self) => {
            self.hook(
                Audio,
                (self) => {
                    if (!Audio.speaker) return;

                    self.value = Audio.speaker.volume;
                },
                "speaker-changed",
            );
        },
    });

export const VolumePopup = () =>
    Box({
        css: `min-height: 2px;
          min-width: 2px;`,
        child: Widget.Revealer({
            transition: "slide_up",
            child: Box({
                className: "volumePopup",
                children: [VolumeIcon(), PercentBar()],
            }),
            attribute: { count: 0 },
            setup: (self) => {
                self.hook(
                    Audio,
                    (self) => {
                        self.revealChild = true;
                        self.attribute.count++;
                        Utils.timeout(1500, () => {
                            self.attribute.count--;

                            if (self.attribute.count === 0)
                                self.revealChild = false;
                        });
                    },
                    "speaker-changed",
                );
            },
        }),
    });
