FROM drunner/baseimage-alpine

ENV TELEPORT_VERSION=1.0.0 \
    GOPATH=/opt/go

RUN apk --update add go git build-base && \
    git clone https://github.com/gravitational/teleport && cd teleport && git checkout -b tags/v${TELEPORT_VERSION} && \
    mkdir -p /opt/go && \
    go get github.com/Sirupsen/logrus && \
    go get github.com/gravitational/teleport/lib/config && \
    go get github.com/gravitational/teleport/lib/defaults && \
    go get github.com/gravitational/teleport/lib/service && \
    go get github.com/gravitational/teleport/lib/sshutils/scp && \
    go get github.com/gravitational/teleport/lib/utils && \
    go get github.com/gravitational/trace && \
    go get github.com/buger/goterm && \
    make teleport && \
    mkdir -p /opt/teleport && cp -R web/dist/* /opt/teleport/. && \
    cp build/teleport /usr/local/bin/teleport && \
    cd / && rm -rf teleport* && rm -rf /opt/go && apk del go git build-base && rm -rf /var/cache/apk/*

RUN mkdir -p /var/lib/teleport && mkdir -p /etc/teleport && chown druser:drgroup /var/lib/teleport

COPY ["teleport.yml", "/etc/teleport/teleport.yml"]
COPY ["drunner", "/drunner"]

USER druser

EXPOSE 3023 3024 3025 3080

CMD ["teleport", "start"]
