import { Audio, Widget, Utils } from "../../imports.js";
import { getAudioIcon } from "../../utils/audio.js";
const { Button } = Widget;

const AudioIcon = () =>
    Widget.Icon({
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
