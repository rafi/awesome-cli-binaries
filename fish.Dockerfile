# syntax = docker/dockerfile:1
# Use Debian 10 for older glib versions.
FROM debian:buster AS builder

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

# Prepare environment
RUN apt-get update \
    && apt-get upgrade --yes --show-upgraded \
    && apt-get install --yes \
        locales automake build-essential pkg-config libssl-dev libtool \
        bison byacc imagemagick ca-certificates curl file \
    && apt-get purge --yes manpages manpages-dev \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

WORKDIR /root

RUN . .cargo/env \
    && cargo install --git https://github.com/faho/fish-shell --branch fish-installer
