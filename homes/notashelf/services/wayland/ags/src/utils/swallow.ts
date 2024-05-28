import { Utils, Variable } from "../imports";
const { exec, execAsync } = Utils;

function genCommand(arg: string) {
    return ["sh", "-c", `ags-hyprctl-swallow ${arg}`];
}

const swallowQuery = genCommand("query");
const swallowToggle = genCommand("toggle");

const getSwallowStatus = async () => {
    try {
        await execAsync(swallowQuery);
        const result = exec("hyprctl -j getoption misc:enable_swallow");
        return JSON.parse(result).set;
    } catch (error) {
        console.error("Error getting swallow status:", error);
        throw error;
    }
};

export const status = Variable(getSwallowStatus());

export const toggleSwallowStatus = () => {
    execAsync(swallowToggle);

    // toggle swallow status
    status.value = !status.value;
};
