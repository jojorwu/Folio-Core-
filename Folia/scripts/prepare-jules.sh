#!/bin/bash
# scripts/prepare-jules.sh

# This script prepares the development environment for an AI agent by generating
# and organizing the necessary source code.
# It is designed to be run from the root of the repository.

echo "🤖 JULES: Starting environment preparation..."

# 1. Define the canonical source directory, which contains the patched Minecraft source.
# This is the source of truth for all vanilla code modifications.
CANONICAL_SRC="Folia/folia-server/src/minecraft/java"

# Check if the sources have been generated. If not, run the necessary Gradle task.
# The `applyPatches` task creates the src/minecraft/java directory.
if [ ! -d "$CANONICAL_SRC" ]; then
    echo "⚙️ Sources not found in $CANONICAL_SRC. Running 'applyPatches' (this may take a while)..."
    # Execute gradlew from the Folia subdirectory
    (cd Folia && ./gradlew applyPatches)
else
    echo "✅ Sources already exist in $CANONICAL_SRC."
fi

# 2. Create the dedicated context directory for the AI agent at the repo root.
# This keeps the agent's workspace separate from the main project files.
CONTEXT_DIR="ai_context"
echo "📁 Creating AI context directory at '$CONTEXT_DIR'..."
mkdir -p "$CONTEXT_DIR/vanilla_ref"
mkdir -p "$CONTEXT_DIR/shadow_workspace"

# 3. Copy the vanilla source code into the 'vanilla_ref' directory.
# This provides the agent with a clean, read-only reference of the current codebase.
# Before copying, we ensure the destination is empty to avoid stale files.
echo "🧹 Clearing old reference sources..."
# Using find and delete is safer than rm -rf on a variable path.
find "$CONTEXT_DIR/vanilla_ref/" -mindepth 1 -delete
echo "📚 Copying reference sources to '$CONTEXT_DIR/vanilla_ref'..."
# We copy the entire source tree to provide full context.
cp -r "$CANONICAL_SRC/." "$CONTEXT_DIR/vanilla_ref/"

# 4. Ensure the context directory is ignored by Git to avoid accidental commits.
# This checks the .gitignore file inside the 'Folia' directory.
GITIGNORE_FILE="Folia/.gitignore"
if ! grep -q "^$CONTEXT_DIR/$" "$GITIGNORE_FILE" &>/dev/null; then
    echo "🛡️ Adding '$CONTEXT_DIR/' to $GITIGNORE_FILE..."
    echo "" >> "$GITIGNORE_FILE" # Add a newline for separation
    echo "# AI Agent Workspace - automatically generated" >> "$GITIGNORE_FILE"
    echo "$CONTEXT_DIR/" >> "$GITIGNORE_FILE"
fi

echo ""
echo "🚀 Environment is ready!"
echo "   - To understand the code, read files from: '$CONTEXT_DIR/vanilla_ref'"
echo "   - To make changes, create and modify files in: '$CONTEXT_DIR/shadow_workspace'"
