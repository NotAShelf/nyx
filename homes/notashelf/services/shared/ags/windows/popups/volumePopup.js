import { Widget, Utils, Audio } from "../../imports.js";
const { Box, Slider, Label } = Widget;

const VolumeIcon = () =>
  Label({
    className: "volPopupIcon",
    connections: [
      [
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
      ],
    ],
  });

const PercentLabel = () =>
  Label({
    className: "volPopupLabel",
    label: "Volume",
    connections: [
      [
        Audio,
        (self) => {
          if (!Audio.speaker) return;

          self.label = `Volume • ${Math.floor(Audio.speaker.volume * 100)}`;
        },
        "speaker-changed",
      ],
    ],
  });

const PercentBar = () =>
  Slider({
    className: "volPopupBar",
    drawValue: false,
    onChange: ({ value }) => (Audio.speaker.volume = value),
    connections: [
      [
        Audio,
        (self) => {
          if (!Audio.speaker) return;

          self.value = Audio.speaker.volume;
        },
        "speaker-changed",
      ],
    ],
  });

export const VolumePopup = () =>
  Box({
    css: `min-height: 1px;
          min-width: 1px;`,
    child: Widget.Revealer({
      transition: "slide_up",
      child: Box({
        className: "volumePopup",
        vertical: true,
        children: [PercentLabel(), PercentBar()],
      }),
      properties: [["count", 0]],
      connections: [
        [
          Audio,
          (self) => {
            self.revealChild = true;
            self._count++;
            Utils.timeout(1500, () => {
              self._count--;

              if (self._count === 0) self.revealChild = false;
            });
          },
          "speaker-changed",
        ],
      ],
    }),
  });
