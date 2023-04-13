#!/usr/bin/env bash

source /opt/utils/message-status.sh

add_label()
{
    if [ -z "$1" ]; then
        echo "Please provide a label name"
        return 1
    fi

    REQUEST_BODY="{\"labels\":[\"$1\"]}"

    curl -L \
      -X POST \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $GITHUB_TOKEN" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      -H "Content-Type: application/json" \
      "$BASE_URL/issues/${PULL_REQUEST_NUMBER}/labels" \
      -d "$REQUEST_BODY"
}

get_repo_labels()
{
    curl -L \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $GITHUB_TOKEN"\
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "$BASE_URL/labels"
}

check_label_exists()
{
    echo "🔍 $(info)Checking if label $1 exists. . ."
    if [[ $(get_repo_labels) =~ $1 ]]; then
        echo "✅ $(success)Label $1 exists. Assigning to pull request. . ."
    else
        echo "⛔ $(error)Label $1 does not exist. Please create it first."
        exit 1
    fi
}
