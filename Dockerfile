# SPDX-FileCopyrightText: Contributors to the Gardener project
#
# SPDX-License-Identifier: Apache-2.0

############# builder
FROM golang:1.27.4 AS builder

WORKDIR /build

# Copy go mod and sum files
COPY go.mod go.sum ./
# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

COPY . .
ARG TARGETARCH
RUN make release GOARCH=$TARGETARCH

############# coredns-config-adapter
FROM gcr.io/distroless/static-debian13:nonroot AS coredns-config-adapter

COPY --from=builder /build/coredns-config-adapter /coredns-config-adapter
ENTRYPOINT ["/coredns-config-adapter"]
