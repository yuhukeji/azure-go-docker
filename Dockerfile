# syntax=docker/dockerfile:1

FROM ubuntu:20.04 AS base

ARG TZ=Asia/Shanghai
RUN ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone
RUN ln -sf /bin/bash /bin/sh

# https://learn.microsoft.com/en-us/azure/ai-services/speech-service/quickstarts/setup-platform?pivots=programming-language-go

# Install platform requirements for Azure speech SDK.
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libssl-dev \
    ca-certificates \
    libasound2 \
    wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install GStreamer to handle compressed audio.
RUN apt-get update && \
    apt-get install -y \
    libgstreamer1.0-0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install the speech SDK for Go.
ENV SPEECHSDK_ROOT="/opt/azure/speechsdk"
RUN mkdir -p "$SPEECHSDK_ROOT" && \
    wget -O SpeechSDK-Linux.tar.gz https://aka.ms/csspeech/linuxbinary && \
    tar --strip 1 -xzf SpeechSDK-Linux.tar.gz -C "$SPEECHSDK_ROOT" && \
    rm -f SpeechSDK-Linux.tar.gz

# Configure the Go environment.
ENV CGO_CFLAGS="-I$SPEECHSDK_ROOT/include/c_api"
ENV CGO_LDFLAGS="-L$SPEECHSDK_ROOT/lib/x64 -lMicrosoft.CognitiveServices.Speech.core"
ENV LD_LIBRARY_PATH="$SPEECHSDK_ROOT/lib/x64:/usr/local/lib:$LD_LIBRARY_PATH"

################################

FROM base AS development

ARG goversion=1.20.2

RUN wget https://dl.google.com/go/go${goversion}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${goversion}.linux-amd64.tar.gz && \
    rm -f go${goversion}.linux-amd64.tar.gz

ENV GOPATH=/go
ENV PATH="$GOPATH/bin:/usr/local/go/bin:$PATH"
