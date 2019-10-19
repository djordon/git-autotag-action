FROM ubuntu:bionic-20191010

LABEL "com.github.actions.name"="Tag the repository"
LABEL "com.github.actions.description"="Updates the repository to the tag"
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="http://github.com/octocat/hello-world"
LABEL "homepage"="http://github.com/actions"
LABEL "maintainer"="Octocat <octocat@github.com>"

RUN apt-get -qq update \
    && apt-get -qq -y --no-install-recommends install \
        ca-certificates \
        curl \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
