FROM ubuntu:18.04

LABEL "com.github.actions.name"="CHANGELOG Generator, DAWG!"
LABEL "com.github.actions.description"="Queries the provided repository's releases and generates a single-file CHANGELOG, dawg."
LABEL "com.github.actions.icon"="edit"
LABEL "com.github.actions.color"="red"

LABEL "repository"="https://github.com/dragonspark/action-changelog-dawg"
LABEL "homepage"="https://blog.dragonspark.us"
LABEL "maintainer"="Mike-EEE <github.actions+dockerfile@dragonspark.network>"

RUN apt-get update \
    && apt-get install wget -y \
    && wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell

 ADD entrypoint.ps1 /entrypoint.ps1
 ENTRYPOINT ["pwsh", "/entrypoint.ps1"]
