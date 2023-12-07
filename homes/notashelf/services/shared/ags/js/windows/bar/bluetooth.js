import { Bluetooth, Widget } from '../../imports.js';
const { Box, Label, Icon } = Widget;

export const BluetoothModule = () =>
  Icon({
    className: 'bluetoothModule',
    connections: [
      [
        Bluetooth,
        self => {
          self.children = Bluetooth.connectedDevices.map(
            ({ iconName, name }) =>
              Label({
                indicator: Widget.Icon(iconName + '-symbolic'),
                child: Widget.Label(name),
              }),
          );
        },
        'notify::connected-devices',
      ],
    ],

    binds: [
      [
        'icon',
        Bluetooth,
        'connected-devices',
        connected => {
          if (!Bluetooth.enabled)
            return 'bluetooth-disabled';
          if (connected.length > 0)
            return 'bluetooth-paired';
          return 'bluetooth-active';
        },
      ],
      [
        'tooltip-text',
        Bluetooth,
        'connected-devices',
        connected => {
          if (!Bluetooth.enabled)
            return 'Bluetooth off';

          if (connected.length > 0) {
            const dev = Bluetooth.getDevice(connected.at(0).address);
            let battery_str = '';

            if (dev.battery_percentage > 0)
              battery_str += ' ' + dev.battery_percentage + '%';


            return dev.name + battery_str;
          }

          return 'Bluetooth on';
        },
      ],
    ],
  });

export const BluetoothWidget = () => {
  return Box({
    className: 'bluetooth',
    cursor: 'pointer',
    child: BluetoothModule(),
    visible: Bluetooth.connectedDevices.length > 0,
  });
};
