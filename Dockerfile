# Frontend Cachge Bust Dockerfile
FROM registry.access.redhat.com/ubi8/go-toolset:1.22.9-1 as builder

RUN git clone https://github.com/akamai/cli-purge 
RUN cd cli-purge && go build -o akamai-purge -ldflags="-s -w"

FROM registry.access.redhat.com/ubi8-minimal:8.10-1154

COPY --from=builder /opt/app-root/src/cli-purge/cli.json .
COPY --from=builder /opt/app-root/src/cli-purge/akamai-purge .

ENTRYPOINT ["/akamai-purge"]
