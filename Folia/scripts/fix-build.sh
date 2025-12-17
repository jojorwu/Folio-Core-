#!/bin/bash
set -e

# This script applies necessary fixes to the generated build.gradle.kts file.
# It is executed from the Folia directory.

# 1. Replace paper-api with folia-api
sed -i 's/implementation(project(":paper-api"))/implementation(project(":folia-api"))/' folia-server/build.gradle.kts

# 2. Add the adventure-bom to manage dependency versions
sed -i '/dependencies {/a \    api(platform("net.kyori:adventure-bom:4.17.0"))' folia-server/build.gradle.kts

# 3. Fix typo in toIntOrNull
sed -i 's/toIntOrnull/toIntOrNull/' folia-server/build.gradle.kts
