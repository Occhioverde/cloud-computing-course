#!/bin/bash
apt purge -y 'docker.io' docker-compose podman
apt autoremove
echo "Ready!"
