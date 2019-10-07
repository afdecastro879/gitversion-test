#!/usr/bin/env bash

DIR="$(dirname "$0")"
source ${DIR}/include.sh

# Setup the repository
git config --global user.email "build@travis-ci.com"
git config --global user.name "Travis CI"
git checkout ${TRAVIS_BRANCH}

if [[ "${TRAVIS_BRANCH}" = "develop" ]]
then
    export TAG=$(docker run --rm -v "$(pwd):/repo" gittools/gitversion:5.0.0-linux-debian-9-netcoreapp2.2 /repo -output json -showvariable FullSemVer)
elif [[ "${TRAVIS_BRANCH}" = "master" ]]
then
    export TAG=$(docker run --rm -v "$(pwd):/repo" gittools/gitversion:5.0.0-linux-debian-9-netcoreapp2.2 /repo -output json -showvariable MajorMinorPatch)
    # Remove all old rfv tags
    git push -q https://${GITHUB_KEY}@github.com/${TRAVIS_REPO_SLUG} -d origin $(git tag -l "*-rfv.*")
fi

# Tag this version
TAG=${TAG//+/-}
git tag v${TAG}
git push -q https://${GITHUB_KEY}@github.com/${TRAVIS_REPO_SLUG} --tags
