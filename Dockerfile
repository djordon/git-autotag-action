FROM ubuntu:focal-20210325

LABEL "com.github.actions.name"="Git auto-tagger"
LABEL "com.github.actions.description"="Tags the repository using the verion from the code"
LABEL "maintainer"="Daniel Jordon"

RUN apt-get -qq update \
    && apt-get -qq --assume-yes --no-install-recommends install \
        ca-certificates \
        git \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
