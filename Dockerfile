FROM ubuntu:latest

LABEL "com.github.actions.name"="It's a CHANGELOG, dawg!"
LABEL "com.github.actions.description"="Generates a single-file CHANGELOG from your repo releases, dawg."
LABEL "com.github.actions.icon"="edit"
LABEL "com.github.actions.color"="red"

LABEL "repository"="https://github.com/dragonspark/action-changelog-dawg"
LABEL "homepage"="https://blog.dragonspark.us"
LABEL "maintainer"="Mike-EEE <github.actions+dockerfile@dragonspark.network>"

RUN docker image ls

# RUN apt-get update \
#    && apt-get install wget -y \
#    && wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
#    && dpkg -i packages-microsoft-prod.deb \
#    && apt-get update \
#    && apt-get install -y powershell

# ADD entrypoint.ps1 /entrypoint.ps1
# ENTRYPOINT ["pwsh", "/entrypoint.ps1"]