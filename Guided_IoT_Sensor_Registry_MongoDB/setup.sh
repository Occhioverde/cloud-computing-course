#!/bin/bash
# Docker is pre-installed and the daemon is already running on the Killercoda ubuntu image.
# Pull the MongoDB image in the background so step 1 is fast.
docker pull mongo:7 > /dev/null 2>&1
echo "Ready"
