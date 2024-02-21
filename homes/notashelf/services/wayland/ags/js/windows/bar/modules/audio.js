import { Audio, Widget, Utils } from "../../../imports.js";
import { getAudioIcon } from "../../../utils/audio.js";
const { Button, Icon } = Widget;

const AudioIcon = () =>
    Icon({
        setup: (self) => {
            self.hook(Audio, getAudioIcon, "speaker-changed");
        },
    });

export const AudioWidget = () => {
    return Button({
        className: "audio",
        cursor: "pointer",
        child: AudioIcon(),
        visible: true,
        onClicked: () => Utils.exec("pavucontrol"),
    });
};
