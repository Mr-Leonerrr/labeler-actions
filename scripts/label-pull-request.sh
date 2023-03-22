#!/bin/bash

REVIEW_STATE=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
  "https://api.github.com/repos/${{ github.repository }}/pulls/${PULL_REQUEST_NUMBER}/reviews" | \
  jq -r 'group_by(.user.login) | map({ login: .[0].user.login, state: (map(.state) | unique)[0] })' | \
  jq -r 'group_by(.state) | map({ state: .[0].state, count: length }) | from_entries')

if [[ $(echo "$REVIEW_STATE" | jq -r '.APPROVED') -ge $(echo "$REVIEW_STATE" | jq -r '.TOTAL / 2') ]]; then
  echo "Half of reviews is approve. Add label 'status:ready-to-merge'"
  curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    -X POST \
    -d '{"labels":["status:ready-to-merge"]}' \
    "https://api.github.com/repos/${{ github.repository }}/issues/${PULL_REQUEST_NUMBER}/labels"
fi

if [[ $(echo "$REVIEW_STATE" | jq -r '.CONFLICTING') -gt 0 ]]; then
  echo "Have conflicts. Add label 'status:conflicts-found'"
  curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    -X POST \
    -d '{"labels":["status:conflicts-found"]}' \
    "https://api.github.com/repos/${{ github.repository }}/issues/${PULL_REQUEST_NUMBER}/labels"
fi

if [[ $(echo "$REVIEW_STATE" | jq -r '.CHANGES_REQUESTED') -gt 0 ]]; then
  echo "Some reviewer have requested changes. Add label 'status:changes-requested'"
  curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "Content-Type: application/json" \
    -X POST \
    -d '{"labels":["status:changes-requested"]}' \
    "https://api.github.com/repos/${{ github.repository }}/issues/${PULL_REQUEST_NUMBER}/labels"
fi
