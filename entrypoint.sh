#!/usr/bin/env bash
# Using /usr/bin/env bash is probably unnecessary but doesn't hurt.
# See https://tldp.org/LDP/abs/html/sha-bang.html#AEN269

# Taken from https://github.com/actions/checkout/issues/760
git config --global --add safe.directory "$GITHUB_WORKSPACE"
git config --global --add safe.directory /github/workspace

VERSION="${1:?Must supply the version. Exiting with status 1.}"

# grep returns error exit status if there is no match, but that is not actually
# an "error" here
TAG=$(git tag | grep --extended-regexp "^${VERSION}$" || true)

if [ ! -z "$TAG" ]
then
    echo "Tag $TAG already exists. Exiting"
    exit 0
fi

COMMIT=$(git rev-parse HEAD)

echo "Tagging the repo with ${VERSION}"

curl --silent --show-error --fail-with-body -X POST https://api.github.com/repos/$GITHUB_REPOSITORY/git/refs \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d @- << EOF
{
  "ref": "refs/tags/${VERSION}",
  "sha": "${COMMIT}"
}
EOF
