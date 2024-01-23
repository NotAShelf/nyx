import { Applications } from "../imports.js";
/**
 * Queries the exact application based on its name.
 * First tries to find the application in the list of applications.
 * If it doesn't find it, then it queries the application by its name.
 *
 * @function queryExact
 * @param {string} appName - The name of the application to query.
 * @returns {Object} The queried application object. Returns null if the application is not found.
 */
export function queryExact(appName) {
    return (
        Applications.list.filter(
            (app) => app.name.toLowerCase() === appName.toLowerCase(),
        )[0] ?? Applications.query(appName)[0]
    );
}
