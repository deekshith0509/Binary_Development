#!/bin/bash

# Check if the user provided a URL
if [ -z "$1" ]; then
    echo "Usage: links <URL>"
    exit 1
fi

# URL shortening service API (TinyURL)
SHORTENER_API="https://tinyurl.com/api-create.php?url="

# Shorten the URL using the API
shortened_url=$(curl -s "${SHORTENER_API}$1")

# Print the shortened URL
echo "Shortened URL: $shortened_url"
