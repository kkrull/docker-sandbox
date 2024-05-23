#!/usr/bin/env bash

set -e

wget -q -O - https://get.docker.io/gpg | apt-key add -
echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list

apt-get update -qq
apt-get install -q -y --force-yes lxc-docker
usermod -a -G docker vagrant

