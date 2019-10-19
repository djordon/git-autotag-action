#!/usr/bin/env bash

VERSION=$(cat mix.exs | grep "version: " | sed -e 's/.*version: "\(.*\)",/\1/')
TAG=$(git tag | grep --extended-regexp "^v${VERSION}$")

if [ ! -z $TAG ]
then 
    echo "Tag $TAG already exists. Exiting"
    exit 0
fi

COMMIT=$(git rev-parse HEAD)

curl --silent --show-error -X POST https://api.github.com/repos/$GITHUB_REPOSITORY/git/refs \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d @- << EOF
{
  "ref": "refs/tags/v${VERSION}",
  "sha": "${COMMIT}"
}
EOF
