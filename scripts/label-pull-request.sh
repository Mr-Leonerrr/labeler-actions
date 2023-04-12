#!/usr/bin/env bash

source /opt/scripts/add-label.sh

echo "Reviewing pull request $PULL_REQUEST_NUMBER in $GITHUB_REPOSITORY"

BASE_URL="https://api.github.com/repos/${GITHUB_REPOSITORY}"
PULLS_ENDPOINT="${BASE_URL}/pulls/${PULL_REQUEST_NUMBER}"
REVIEW_ENDPOINT="$PULLS_ENDPOINT/reviews"

# Get the pull request reviews and group them by state
REVIEW_STATE=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" $REVIEW_ENDPOINT)

# Extract the review state counts from the JSON output
APPROVED_COUNT=$(echo "$REVIEW_STATE" | grep -o '"state":"APPROVED"' | wc -l)
CHANGES_REQUESTED_COUNT=$(echo "$REVIEW_STATE" | grep -o '"state":"CHANGES_REQUESTED"' | wc -l)
COMMENTED_COUNT=$(echo "$REVIEW_STATE" | grep -o '"state":"COMMENTED"' | wc -l)
DISMISSED_COUNT=$(echo "$REVIEW_STATE" | grep -o '"state":"DISMISSED"' | wc -l)
TOTAL_COUNT=$((APPROVED_COUNT + CHANGES_REQUESTED_COUNT + COMMENTED_COUNT + DISMISSED_COUNT))

# Print the pull request review state counts as a JSON object
echo "{ \"APPROVED\": $APPROVED_COUNT, \"CHANGES_REQUESTED\": $CHANGES_REQUESTED_COUNT, \"COMMENTED\": $COMMENTED_COUNT, \"DISMISSED\": $DISMISSED_COUNT, \"TOTAL\": $TOTAL_COUNT }"

MERGEABLE=$(echo "$PULL_REQUEST_INFO" | grep -o '"mergeable":.*,' | cut -d: -f2- | tr -d '",' | tr '[:upper:]' '[:lower:]')

if [ $MERGEABLE = "false" ]; then
    echo "Pull request is not mergeable. Adding label 'status:conflicts-found'"
    add_label "status:conflicts-found"
    exit 0
fi

if [[ $APPROVED_COUNT -ge $((TOTAL_COUNT / 2)) ]]; then
    echo "Half of reviews are approved. Adding label 'status:ready-to-merge'"
    add_label "status:ready-to-merge"
    exit 0
fi

if [[ $CHANGES_REQUESTED_COUNT -ge 1 ]]; then
    echo "There are reviews requesting changes. Adding label 'status:changes-requested'"
    add_label "status:changes-requested"
    exit 0
fi
