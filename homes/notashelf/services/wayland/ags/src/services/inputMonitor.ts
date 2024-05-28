import { Utils, Service } from "../imports.js";
const { subprocess } = Utils;

class InputMonitorService extends Service {
    static {
        Service.register(
            this,
            {
                keypress: ["jsobject"],
                keyrelease: ["jsobject"],
                keyrepeat: ["jsobject"],
                event: ["jsobject"],
            },
            {},
        );
    }

    constructor() {
        super();
        this._evtest = subprocess("evtest /dev/input/event3", (str) =>
            this._handleEvent(str),
        );
    }

    _handleEvent(event) {
        //ignore initial output
        if (!event.startsWith("Event")) return;
        //ignore SYN_REPORTS
        if (event.includes("SYN")) return;
        const eventData = event.substring(7).split(", ");
        const eventInfo = {};
        //evetnInfo structure:
        //{
        //  time: unix timstamp
        //  type: event type
        //  code: keycode (this is the hardware keycode)
        //  value: depends on type, for EV_KEY 0->release, 1->press, 2->repeat(when holding)
        //}

        eventData.forEach((data) => {
            const [key, value, value2] = data.split(" ");
            eventInfo[key] = isNaN(value) ? value : Number(value);
            if (key === "code") eventInfo["name"] = value2.slice(1, -1);
        });
        //only emit on EV_KEY
        if (eventInfo.type === 1) {
            if (eventInfo.value === 0) this.emit("keyrelease", eventInfo);
            if (eventInfo.value === 1) this.emit("keypress", eventInfo);
            if (eventInfo.value === 2) this.emit("keyrepeat", eventInfo);
        }
        //emit on every event, just in case, you need it
        this.emit("event", eventInfo);
    }
}

export default new InputMonitorService();
