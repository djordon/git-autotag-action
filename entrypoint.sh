#!/usr/bin/env bash

# Taken from https://github.com/actions/checkout/issues/760
git config --global --add safe.directory "$GITHUB_WORKSPACE"
git config --global --add safe.directory /github/workspace

DEFAULT_VERSION='cat VERSION'

VERSION=$(eval ${VERSION_COMMAND:-$DEFAULT_VERSION} 2>/dev/null)

if [ -z "$VERSION_PREFIX" ];
then
    VERSION_PREFIX="v"
fi

if [ -z "$VERSION" ]
then
    echo "VERSION_COMMAND yielded an empty version. That's probably unexpected. Exiting with status 1."
    exit 1
fi

TAG=$(git tag | grep --extended-regexp "^${VERSION_PREFIX}${VERSION}$")

if [ ! -z "$TAG" ]
then
    echo "Tag $TAG already exists. Exiting"
    exit 0
fi

COMMIT=$(git rev-parse HEAD)

echo "Tagging the repo with ${VERSION_PREFIX}${VERSION}"

curl --silent --show-error -X POST https://api.github.com/repos/$GITHUB_REPOSITORY/git/refs \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d @- << EOF
{
  "ref": "refs/tags/${VERSION_PREFIX}${VERSION}",
  "sha": "${COMMIT}"
}
EOF
