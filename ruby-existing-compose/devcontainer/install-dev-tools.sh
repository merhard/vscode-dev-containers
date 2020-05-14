#!/usr/bin/env bash

set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends apt-utils dialog 2>&1

# Install vim, git, process tools, lsb-release
apt-get install -y \
    vim \
    git \
    openssh-client \
    less \
    iproute2 \
    procps \
    lsb-release

# Install debug tools
gem install \
    ruby-debug-ide \
    debase

# Install personal dev environment requirements
apt-get install -y \
    zsh \
    silversearcher-ag

# Clean up
apt-get autoremove -y
apt-get clean -y
rm -rf /var/lib/apt/lists/*
