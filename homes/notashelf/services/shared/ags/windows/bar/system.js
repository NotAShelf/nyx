import { Utils, Widget } from '../../imports.js';
const { execAsync } = Utils;
const { Box } = Widget;

const cpu = () =>
    Box({
        vertical: true,
        children: [
            Widget.Label({
                className: 'processor',
                label: '',
            }),
            Widget.Label({
                className: 'processorValue',
                connections: [
                    [
                        2000,
                        self =>
                            execAsync([
                                'sh',
                                '-c',
                                'top -bn1 | rg \'%Cpu\' | tail -1 | awk \'{print 100-$8}\'',
                            ])
                                .then(
                                    r =>
                                        (self.label =
											Math.round(Number(r)) + '%'),
                                )
                                .catch(err => print(err)),
                    ],
                ],
            }),
        ],
    });

const memory = () =>
    Box({
        vertical: true,
        children: [
            Widget.Label({
                className: 'type',
                label: '󰍛',
            }),
            Widget.Label({
                className: 'value',

                connections: [
                    [
                        2000,
                        self =>
                            execAsync([
                                'sh',
                                '-c',
                                'free | tail -2 | head -1 | awk \'{print $3/$2*100}\'',
                            ])
                                .then(
                                    r =>
                                        (self.label =
											Math.round(Number(r)) + '%'),
                                )
                                .catch(err => print(err)),
                    ],
                ],
            }),
        ],
    });

export const SystemInfo = () =>
    Box({
        className: 'systemInfo',
        vertical: true,
        cursor: 'pointer',
        children: [cpu(), memory()],
    });
