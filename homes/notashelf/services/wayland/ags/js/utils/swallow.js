import { App, Utils } from "../imports.js";
const { exec, execAsync } = Utils;

function genCommand(arg) {
    return ["sh", "-c", `${App.configDir}/bin/hyprctl_swallow ${arg}`];
}

const swallowQuery = genCommand("query");
const swallowToggle = genCommand("toggle");

export const getSwallowStatus = () => {
    execAsync(swallowQuery);

    let result = exec("hyprctl -j getoption misc:enable_swallow");
    return JSON.parse(result).set;
};

export const status = Variable(getSwallowStatus());

export const toggleSwallowStatus = () => {
    execAsync(swallowToggle);

    // toggle swallow status
    status.value = !status.value;
};
