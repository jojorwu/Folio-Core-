#!/bin/bash
# This script is executed by Jules
echo "Setting up Folio environment..."
# 1. Configure Git (required by Paperweight)
git config --global user.email "jules@google.com"
git config --global user.name "Jules AI"

# 2. Download Minecraft and apply patches (this will create the work/ directory)
./gradlew applyPatches

# 3. Output the path to the sources so Jules knows where to find them
echo "Minecraft sources are ready at: Folia/folia-server/src/minecraft/java/"
