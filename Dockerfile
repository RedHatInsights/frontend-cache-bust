FROM registry.access.redhat.com/ubi8/go-toolset:1.18.9-13 as builder

USER 0

RUN dnf install -y git \
    && git clone --depth=1 https://github.com/akamai/cli-purge \
    && cd cli-purge \
    && go mod init github.com/akamai/cli-purge \
    && go get github.com/akamai/cli-purge \
    && go mod vendor \
    && mkdir -p /cli/.akamai-cli/src/cli-purge/bin \
    && go build -o /cli/.akamai-cli/src/cli-purge/bin/akamai-purge -ldflags="-s -w" \
    && cp cli.json /cli/.akamai-cli/src/cli-purge/bin/cli.json

ENTRYPOINT ["/cli/.akamai-cli/src/cli-purge/bin/akamai-purge"]
