String.prototype.replaceChars = function (char, replacement) {
    return this.split(char).join(replacement);
};

const searchHandlers = {
    "-y": (query) =>
        `https://www.youtube.com/results?search_query=${query.replaceChars(" ", "+")}`,
    "-w": (query) =>
        `https://en.wikipedia.org/w/index.php?search=${query.replaceChars(" ", "%20")}`,
    "-m": (query) =>
        `http://www.wolframalpha.com/input/?i=${query.replaceChars("+", "%2B")}`,
    "-h": (query) =>
        `http://alpha.wallhaven.cc/search?q=${query}&categories=111&purity=100&resolutions=1920x1080&sorting=relevance&order=desc`,
    default: (query) =>
        `https://search.notashelf.dev/search?q=${query.replaceChars(" ", "+")}&categories=general`,
};

function search(query) {
    const searchPrefix = query.substring(0, 2);
    const handler = searchHandlers[searchPrefix] || searchHandlers["default"];
    window.location = handler(query.substring(3));
}

window.onload = function () {
    const searchInput = document.getElementById("searchbox");
    if (searchInput) {
        searchInput.addEventListener("keypress", function (event) {
            if (event.key === "Enter") {
                // Using event.key instead of event.keyCode
                search(this.value);
            }
        });
    }
};
