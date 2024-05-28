import { Applications, Utils } from "../imports";
const { execAsync } = Utils;
const { list, query } = Applications;

/**
 * Queries the exact application based on its name.
 * First tries to find the application in the list of applications.
 * If it doesn't find it, then it queries the application by its name.
 *
 * @function queryExact
 * @param {string} appName - The name of the application to query.
 * @returns {Object} The queried application object. Returns null if the application is not found.
 */
export function queryExact(appName: string): object {
    return (
        list.filter(
            (app) => app.name.toLowerCase() === appName.toLowerCase(),
        )[0] ?? query(appName)[0]
    );
}

/**
 * Tries to launch an application based on its name.
 * First it tries to kill the application if it's already running.
 * Regardless of whether the killing has been successful or not, it
 * tries to launch the application.
 *
 * @function launchApp
 * @param {string} appName - The name of the application to launch.
 * @returns {void}
 */
export function launchApp(appName) {
    if (queryExact(appName)) {
        execAsync(["sh", "-c", `killall ${appName}`]);
    }

    execAsync(["sh", "-c", `${appName}`]);
}
