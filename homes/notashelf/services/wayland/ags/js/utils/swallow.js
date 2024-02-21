import { App, Utils } from "../imports.js";
const { execAsync } = Utils;

function genCommand(arg) {
    return ["sh", "-c", `${App.configDir}/bin/hyprctl_swallow ${arg}`];
}

const swallowQuery = genCommand("query");
const swallowToggle = genCommand("toggle");

export const getSwallowStatus = async () => {
    const result = await execAsync(swallowQuery);
    return JSON.parse(result).status;
};

export const toggleSwallowStatus = () => {
    execAsync(swallowToggle);
};
