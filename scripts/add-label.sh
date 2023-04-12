#!/usr/bin/env bash

BASE_URL="https://api.github.com/repos/${GITHUB_REPOSITORY}"
PULL_REQUEST_NUMBER="5"

add_label()
{
    if [ -z "$1" ]; then
        echo "Please provide a label name"
        return 1
    fi

    echo "Adding label '$1'"

    REQUEST_BODY="{\"labels\":[\"$1\"]}"

    echo "Request body: $REQUEST_BODY"

    curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    -X POST \
    -d REQUEST_BODY \
    "$BASE_URL/issues/${PULL_REQUEST_NUMBER}/labels"
}
