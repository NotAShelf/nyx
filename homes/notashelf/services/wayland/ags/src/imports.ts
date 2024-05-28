export const require = async (file: string) =>
    (await import(resource(file))).default;
export const resource = (file: string) =>
    `resource:///com/github/Aylur/ags/${file}.js`;
export const fromService = async (service: string) =>
    await Service.import(`${service}`);
export const requireCustom = async (path: string) =>
    (await import(path)).default;

export const App = await require("app");
export const GLib = await requireCustom("gi://GLib?version=2.0");
export const Gio = await requireCustom("gi://Gio");
export const Gtk = await requireCustom("gi://Gtk?version=3.0");
export const Service = await require("service");
export const Utils = await import(resource("utils"));
export const Variable = await require("variable");
export const Widget = await require("widget");

// Services
export const Battery = await fromService("battery");
export const Bluetooth = await fromService("bluetooth");
export const Hyprland = await fromService("hyprland");
export const Mpris = await fromService("mpris");
export const Network = await fromService("network");
export const Applications = await fromService("applications");
export const Audio = await fromService("audio");
export const Notifications = await fromService("notifications");
export const SystemTray = await fromService("systemtray");
