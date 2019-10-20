FROM ubuntu:bionic-20191010

LABEL "com.github.actions.name"="Git auto-tagger"
LABEL "com.github.actions.description"="Tags the repository using the verion from the code"
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="purple"

LABEL "maintainer"="Daniel Jordon"

RUN apt-get -qq update \
    && apt-get -qq -y --no-install-recommends install \
        ca-certificates \
        curl \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
