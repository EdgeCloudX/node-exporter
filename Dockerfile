ARG OS="linux"
FROM golang:1.19-alpine AS build-stage

LABEL maintainer="The Prometheus Authors <prometheus-developers@googlegroups.com>"
LABEL DOCKER_REPO=cloudx2021/node-exporter
LABEL GITHUB_REPO=EdgeCloudX/node-exporter

ADD . /go/src/prometheus/node-exporter
WORKDIR /go/src/prometheus/node-exporter
RUN apk -U --no-cache add make && make build

FROM alpine:latest
COPY --from=build-stage /go/src/prometheus/node-exporter/build/node-exporter /bin/node-exporter
RUN rm -rf /go/src/prometheus/*

EXPOSE      9100
USER        nobody
ENTRYPOINT  [ "/bin/node-exporter" ]
