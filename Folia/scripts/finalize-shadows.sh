#!/bin/bash
# scripts/finalize-shadows.sh

# Exit immediately if a command exits with a non-zero status.
set -e

# This script applies changes from the 'shadow workspace' to the main source tree
# and then generates patch files that the Folia build system can use.
# It is designed to be run from the root of the repository.

SHADOW_DIR="ai_context/shadow_workspace"
# The root of the vanilla source code, which is a git repository managed by Paperweight.
# The path must be relative to the repository root.
SOURCE_GIT_ROOT="Folia/folia-server/src/minecraft"
TARGET_SRC_DIR="$SOURCE_GIT_ROOT/java"

echo "🔨 Applying shadow changes to the patch system..."

# Check if there are any files to process
if [ -z "$(find "$SHADOW_DIR" -type f -name "*.java")" ]; then
    echo "🤷 No changes found in $SHADOW_DIR. Nothing to do."
    exit 0
fi

# Iterate over all Java files that the agent has modified in the shadow workspace.
find "$SHADOW_DIR" -type f -name "*.java" | while read shadow_file; do
    # Determine the file's path relative to the shadow directory.
    # e.g., "ai_context/shadow_workspace/net/minecraft/server/level/ServerLevel.java"
    # becomes "net/minecraft/server/level/ServerLevel.java"
    relative_path="${shadow_file#$SHADOW_DIR/}"

    # Construct the full destination path in the actual source tree.
    target_file="$TARGET_SRC_DIR/$relative_path"

    echo "📝 Applying changes for $relative_path..."

    # Ensure the destination directory exists, creating it if necessary.
    mkdir -p "$(dirname "$target_file")"

    # Copy the modified file, overwriting the original.
    cp "$shadow_file" "$target_file" || { echo "❌ ERROR: Failed to copy '$relative_path'."; exit 1; }
done

echo "📁 Entering the source code repository to commit changes..."
cd "$SOURCE_GIT_ROOT" || { echo "❌ ERROR: Could not navigate to the source git root at '$SOURCE_GIT_ROOT'."; exit 1; }

echo "➕ Staging all changes for the patch..."
git add .

# Only commit if there are changes to be staged.
if ! git diff-index --quiet HEAD; then
    echo "💬 Committing the staged changes..."
    # This commit is temporary; its purpose is to be converted into a patch file.
    git commit -m "Folia: Apply automated shadow source updates" || { echo "❌ ERROR: 'git commit' failed."; exit 1; }
else
    echo "✅ No changes to commit."
fi


echo "🔙 Returning to the project root..."
cd - > /dev/null

echo "🔥 Rebuilding patches from the commit..."
# The gradlew script must be executed from the 'Folia' directory.
(cd Folia && ./gradlew rebuildPatches) || { echo "❌ ERROR: Gradle 'rebuildPatches' failed. Please check the logs."; exit 1; }

echo "✅ Done! Check the 'Folia/patches/server/' directory for new or updated patch files."
