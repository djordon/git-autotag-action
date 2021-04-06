#!/usr/bin/env bash

DEFAULT_VERSION='cat VERSION'

VERSION=$(eval ${VERSION_COMMAND:-$DEFAULT_VERSION} 2>/dev/null)
V="v"

if [[ ${PREPEND_V} == "false" ]];
then
    V=""
fi

if [ -z $VERSION ]
then
    echo "VERSION_COMMAND yielded an empty version. That's probably unexpected. Exiting with status 1."
    exit 1
fi

TAG=$(git tag | grep --extended-regexp "^${V}${VERSION}$")

if [ ! -z $TAG ]
then
    echo "Tag $TAG already exists. Exiting"
    exit 0
fi

echo "The tag is: $TAG, but why"

COMMIT=$(git rev-parse HEAD)

curl --silent --show-error -X POST https://api.github.com/repos/$GITHUB_REPOSITORY/git/refs \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d @- << EOF
{
  "ref": "refs/tags/${V}${VERSION}",
  "sha": "${COMMIT}"
}
EOF
