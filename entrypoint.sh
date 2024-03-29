#!/usr/bin/env bash
# Using /usr/bin/env bash is probably unnecessary but doesn't hurt.
# See https://tldp.org/LDP/abs/html/sha-bang.html#AEN269

TAG="${1:?Must supply the tag. Exiting with status 1.}"

# Taken from https://github.com/actions/checkout/issues/760
git config --global --add safe.directory "$GITHUB_WORKSPACE"
git config --global --add safe.directory /github/workspace

# We do not want empty strings as the tag, but this is already checked for
# above when we define TAG.
if [ $(git tag --list "$TAG") ]
then
    echo "Tag $TAG already exists. Exiting"
    exit 0
fi

echo "Tagging the repo with ${TAG} to commit ${GITHUB_SHA:-$(git rev-parse HEAD)}"

# Create a lightweight tag
# See https://git-scm.com/book/en/v2/Git-Basics-Tagging for more
git tag ${TAG}
git push origin ${TAG}
