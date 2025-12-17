#!/bin/bash
set -e

# This script is executed by Jules
echo "Setting up Folio environment..."
# 1. Configure Git (required by Paperweight)
git config --global user.email "jules@google.com"
git config --global user.name "Jules AI"

# 2. Download Minecraft and apply patches. This will generate the build.gradle.kts.
./gradlew applyPatches

# 3. Fix the generated build.gradle.kts.
./scripts/fix-build.sh

# 4. Re-run applyPatches to apply the fixes.
./gradlew applyPatches

# 5. Output the path to the sources so Jules knows where to find them
echo "Minecraft sources are ready at: Folia/folia-server/src/minecraft/java/"
