#!/usr/bin/env bash

BASE_URL="https://api.github.com/repos/${GITHUB_REPOSITORY}"

add_label()
{
    if [ -z "$1" ]; then
        echo "Please provide a label name"
        return 1
    fi

    echo "Adding label '$1'"

    REQUEST_BODY="{\"labels\":[\"$1\"]}"

    echo "Request body: $REQUEST_BODY"

    curl -L \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    -H "Content-Type: application/json" \
    "$BASE_URL/issues/${PULL_REQUEST_NUMBER}/labels" \
    -d "$REQUEST_BODY"
}
