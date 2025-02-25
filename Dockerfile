#############      builder                                  #############
FROM golang:1.17.9 AS builder

WORKDIR /go/src/github.com/gardener/machine-controller-manager
COPY . .

RUN .ci/build

#############      base                                     #############
FROM alpine:3.15.4 as base

RUN apk add --update bash curl tzdata
WORKDIR /

#############      machine-controller-manager               #############
FROM base AS machine-controller-manager

COPY --from=builder /go/src/github.com/gardener/machine-controller-manager/bin/rel/machine-controller-manager /machine-controller-manager
ENTRYPOINT ["/machine-controller-manager"]
