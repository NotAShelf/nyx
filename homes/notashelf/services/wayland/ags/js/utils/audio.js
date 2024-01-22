import { Audio } from "../imports.js";

const audio = {
    mixer: "",
    mic: {
        muted: "microphone-disabled-symbolic",
        low: "microphone-sensitivity-low-symbolic",
        medium: "microphone-sensitivity-medium-symbolic",
        high: "microphone-sensitivity-high-symbolic",
    },
    volume: {
        muted: "audio-volume-muted-symbolic",
        low: "audio-volume-low-symbolic",
        medium: "audio-volume-medium-symbolic",
        high: "audio-volume-high-symbolic",
        overamplified: "audio-volume-overamplified-symbolic",
    },
    type: {
        headset: "audio-headphones-symbolic",
        speaker: "audio-speakers-symbolic",
        card: "audio-card-symbolic",
    },
};

export const getAudioIcon = (self) => {
    if (!Audio.speaker) return;

    const { muted, low, medium, high, overamplified } = audio.volume;

    if (Audio.speaker.is_muted) return (self.icon = muted);

    /** @type {Array<[number, string]>} */
    const cons = [
        [101, overamplified],
        [67, high],
        [34, medium],
        [1, low],
        [0, muted],
    ];

    self.icon = cons.find(([n]) => n <= Audio.speaker.volume * 100)?.[1] || "";
};
