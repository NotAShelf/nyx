String.prototype.replaceChars = function (character, replacement) {
    return this.split(character).join(replacement);
};

function search(query) {
    const searchPrefix = query.substring(0, 2);
    query = query.substring(3);

    switch (searchPrefix) {
        case "-a":
            window.location = `http://www.amazon.com/s/ref=nb_sb_noss_1?url=search-alias%3Daps&field-keywords=${query.replaceChars(
                " ",
                "+",
            )}`;
            break;

        case "-y":
            window.location = `https://www.youtube.com/results?search_query=${query.replaceChars(
                " ",
                "+",
            )}`;
            break;

        case "-w":
            window.location = `https://en.wikipedia.org/w/index.php?search=${query.replaceChars(
                " ",
                "%20",
            )}`;
            break;

        case "-m":
            window.location = `http://www.wolframalpha.com/input/?i=${query.replaceChars(
                "+",
                "%2B",
            )}`;
            break;

        case "-h":
            window.location = `http://alpha.wallhaven.cc/search?q=${query}&categories=111&purity=100&resolutions=1920x1080&sorting=relevance&order=desc`;
            break;

        default:
            window.location = `https://search.notashelf.dev/search?q=${query.replaceChars(
                " ",
                "+",
            )}&categories=general`;
    }
}

window.onload = function () {
    const searchInput = document.getElementById("searchbox");
    if (searchInput) {
        searchInput.addEventListener("keypress", function (event) {
            if (event.keyCode === 13) {
                search(this.value);
            }
        });
    }
};

//
// To add a new search provider, paste the following between the last "break;" and "default:" (Line 39 & 40)
//
//         case "-a":
//          query = query.substr(3);
//          window.location =
//             "https://en.website.com/" +
//             query.replaceChars(" ", "%20");
//          break;
//
// -a on ln68 should be replaced with a "-letter" of your choice. You can also change it to !a, .a, /a etc.
// https://en.website.com/ on ln70 should be replaced with the search page of the website. To find this, make a few searches on your website.
//Try to identify where your search is in the URL. If you're not sure, post in the thread and someone should help you out
//
// You can use the above two to modify an existing rule
//
// If you wish to change the number of characters in a "case", you need to change the line below, changing query.substr() to n+1, n being the number of characters.
// This ensures that when you search for something, the whole of your idenfier and the space between the identifier and query are removed.
