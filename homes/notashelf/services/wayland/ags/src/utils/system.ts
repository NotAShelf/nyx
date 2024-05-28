// generalized function to get class name based on value and thresholds
export const getClass = (v: number, thresholds: any[]) => {
    const val = v * 100;
    const className = thresholds.find(([threshold]) => threshold <= val)[1];
    return className;
};

// thresholds and class names for memory
export const memThresholds = [
    [100, "memCritical"],
    [75, "memHigh"],
    [35, "memMod"],
    [5, "memLow"],
    [0, "memIdle"],
    [-1, "memRevealer"],
];

// thresholds and class names for CPU
export const cpuThresholds = [
    [100, "cpuCritical"],
    [75, "cpuHigh"],
    [35, "cpuMod"],
    [5, "cpuLow"],
    [0, "cpuIdle"],
    [-1, "cpuRevealer"],
];

// get class names for memory and CPU
export const getMemClass = (v: number) => getClass(v, memThresholds);
export const getCpuClass = (v: number) => getClass(v, cpuThresholds);
