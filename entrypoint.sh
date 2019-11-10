#!/usr/bin/env bash

DEFAULT_VERSION='cat mix.exs \
    | grep --line-buffer "version: " \
    | grep --extended-regexp --only-matching "\"[-0-9\.\+a-zA-Z]+\"" \
    | grep --extended-regexp --only-matching "[-0-9\.\+a-zA-Z]+"'

VERSION=$(eval ${VERSION_COMMAND:-$DEFAULT_VERSION})

if [ -z $VERSION ]
then 
    echo "Version command yielded an empty version. Exiting"
    exit 0
fi

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
