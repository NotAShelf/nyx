import { Widget, Utils } from '../../imports.js';
const { exec, execAsync } = Utils;
const { Label, Box } = Widget;

const Time = () => Label({
    className: 'timeLabel',
    connections: [
        [1000, self => self.label = exec('date "+%I%n%M"')],

        [1000, self => execAsync(['date', '+%I%n%M'])
            .then(time => self.label = time).catch(console.error)]
    ],
});

export const Clock = () => Box({
    className: 'clock',
    vertical: true,
    children: [
        Time(),
    ],
});