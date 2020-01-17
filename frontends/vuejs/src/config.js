// Reads a JSON string from a DOM element and returns the parsed object.
// Returns an empty object when called from non-browser environments.
export default function getConfig(selector) {
    let config = {};
    if (document && document.querySelector) {
        const configEl = document.querySelector(selector);
        if (configEl) {
            config = Object.freeze(JSON.parse(configEl.textContent));
        }
    }
    return config;
}
