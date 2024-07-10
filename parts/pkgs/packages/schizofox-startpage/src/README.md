# Adding a New Search Provider

## Choose a Unique Identifier

First, decide on a unique identifier for your search provider. This can be a
letter, symbol, or combination thereof, such as `-a`, `!a`, `.a`, `/a`, etc.
Ensure that your chosen identifier does not conflict with existing ones in the
script.

## Modify the Switch Statement

Locate the switch statement within the `search` function. You'll be inserting a
new case block right before the `default:` case. Here's a template for the new
case block:

```javascript
case "-identifier":           // replace "-identifier" with your chosen identifier
    query = query.substr(3);  // Adjust the number inside substr() if your identifier is longer
    // replace the URL with your search provider's URL
    window.location = "https://example.com/search?" + query.replaceChars(" ", "%20");
    break;
```

Make sure to replace `-identifier` with your chosen identifier and adjust the
`substr()` argument if necessary. Also, make sure to replace the example URL
with the actual search URL of your provider.

<!-- deno-fmt-ignore-start -->

> [!NOTE]
> Pay close attention to how the query parameters are structured in the URL.

<!-- deno-fmt-ignore-end -->

## Adjusting the Substring Index

If your chosen identifier is longer than two characters, you'll need to adjust
the argument passed to `substr()` accordingly. The general rule is `n + 1`,
where `n` is the length of your identifier. This will ensure that the entire
identifier and the space following it are removed from the query string.

## Additional Notes

- When determining the search URL for your provider, conduct a few test searches
  on their website. Look for patterns in the URL that indicate how queries are
  passed. You _might_ run into weird edge cases.
