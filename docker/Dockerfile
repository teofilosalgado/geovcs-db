FROM golang:1.26-trixie AS builder

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends --assume-yes \
        build-essential \
        libicu-dev \
        libgeos-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /go/src
COPY ./dolt/ /go/src/dolt/
COPY ./go-mysql-server/ /go/src/go-mysql-server/

ENV CGO_ENABLED=1
RUN go work init && \
    go work use ./go-mysql-server && \
    go work use ./dolt/go && \
    go build -o /go/bin/dolt ./dolt/go/cmd/dolt

FROM debian:trixie

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends --assume-yes \
        tini \
        libicu-dev \
        libgeos-dev && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/dolt /usr/local/bin/dolt

RUN /usr/local/bin/dolt version

RUN mkdir /docker-entrypoint-initdb.d && \
    mkdir -p /var/lib/dolt && \
    chmod 755 /var/lib/dolt

COPY ./dolt/docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

VOLUME /var/lib/dolt
EXPOSE 3306 33060 7007
WORKDIR /var/lib/dolt
ENTRYPOINT ["tini", "--", "/usr/local/bin/docker-entrypoint.sh"]

