#!/usr/bin/env bash

set -e

DIR="$(dirname "$0")"
source "${DIR}/include.sh"

if [[ "${TRAVIS_BRANCH}" = "master" ]]
then
    curl -v -d "{\"tag_name\": \"$TAG\"}" -H "Authorization: token ${GITHUB_KEY}" -X POST "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/releases"
fi
