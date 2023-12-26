import { Service } from "../imports.js";
const { Gio } = imports.gi;

class DirectoryMonitorService extends Service {
    static {
        Service.register(this, {}, {});
    }

    _monitors = [];

    constructor() {
        super();
    }

    recursiveDirectoryMonitor(directoryPath) {
        const directory = Gio.File.new_for_path(directoryPath);
        const monitor = directory.monitor_directory(
            Gio.FileMonitorFlags.NONE,
            null,
        );
        this._monitors.push(monitor);

        monitor.connect(
            "changed",
            (fileMonitor, file, otherFile, eventType) => {
                if (eventType === Gio.FileMonitorEvent.CHANGES_DONE_HINT) {
                    this.emit("changed");
                }
            },
        );

        const enumerator = directory.enumerate_children(
            "standard::*",
            Gio.FileQueryInfoFlags.NONE,
            null,
        );

        let fileInfo;
        while ((fileInfo = enumerator.next_file(null)) !== null) {
            const childPath = directoryPath + "/" + fileInfo.get_name();
            if (fileInfo.get_file_type() === Gio.FileType.DIRECTORY) {
                this.recursiveDirectoryMonitor(childPath);
            }
        }
    }
}

const service = new DirectoryMonitorService();
export default service;
