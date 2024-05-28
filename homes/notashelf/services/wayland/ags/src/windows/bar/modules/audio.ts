import { Audio, Widget } from "../../../imports";
import { getAudioIcon } from "../../../utils/audio";
import { launchApp } from "../../../utils/global";

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
		visible: true,
		child: AudioIcon(),
		onClicked: () => launchApp("pavucontrol"),
	});
};
