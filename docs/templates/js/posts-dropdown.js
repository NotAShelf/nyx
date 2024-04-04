function fetchPosts() {
    fetch("/posts.json")
        .then((response) => response.json())
        .then((data) => {
            const dropdownContent = document.getElementById("dropdown-content");
            data.posts.forEach((post) => {
                const postLink = document.createElement("a");
                postLink.href = post.path; // we could use posts.url here, but it messes with local serving
                postLink.textContent = post.title;
                dropdownContent.appendChild(postLink);
            });
        })
        .catch((error) => console.error("Error fetching posts:", error));
}

function isInPostsDirectory() {
    return window.location.pathname.startsWith("/posts/");
}

function isIndexPage() {
    return (
        window.location.pathname === "/" ||
        window.location.pathname === "/index.html"
    );
}

document.addEventListener("DOMContentLoaded", () => {
    if (isIndexPage() || isInPostsDirectory()) {
        fetchPosts();
    }
});
