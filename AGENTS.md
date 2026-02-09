# Agent Instructions for Folia Development ("Shadow Source" Workflow)

This document provides essential instructions for AI agents working on this Folia project. Adhering to these guidelines is critical for success.

## 1. Project Architecture: The "Shadow Source" Workflow

To simplify development and avoid manual patch editing, this project uses a "Shadow Source" workflow. As an AI agent, you will no longer interact with `.patch` files directly. Instead, you will work with full Java source files in a dedicated workspace.

## 2. Initial Workspace Setup

At the beginning of any task, you **must** set up your workspace to generate the necessary Minecraft source code. This is done by running the `prepare-jules.sh` script.

Run the following command from the repository root:
```bash
./Folia/scripts/prepare-jules.sh
```
This script does the following:
1.  **Generates Vanilla Sources:** It runs `./gradlew applyPatches` to create a local copy of the Minecraft source code with all the latest Folia and Paper patches applied.
2.  **Creates a Reference Directory:** It copies the generated `net.minecraft` source files into `ai_context/vanilla_ref/`. This directory is for **reading only**. It provides you with the full context of the current state of any file you might need to modify.
3.  **Creates a Workspace Directory:** It creates an empty directory at `ai_context/shadow_workspace/`. This is where you will do all your work.

## 3. Development Workflow

Your development process is as follows:

1.  **Read from `vanilla_ref`:** To understand the current implementation of a vanilla Minecraft file, read it from the `ai_context/vanilla_ref/` directory. For example, to inspect `ServerLevel.java`, you would read `ai_context/vanilla_ref/net/minecraft/server/level/ServerLevel.java`.

2.  **Copy and Edit in `shadow_workspace`:** Before making changes, copy the file from `vanilla_ref` to your `shadow_workspace`. For example:
    ```bash
    cp ai_context/vanilla_ref/net/minecraft/server/level/ServerLevel.java ai_context/shadow_workspace/
    ```
    Then, edit the file in `ai_context/shadow_workspace/` as you would in a standard Java project.

3.  **Finalize Changes:** After you have completed your code modifications in the `shadow_workspace`, the changes need to be converted into a `.patch` file and applied to the project. This is done by running the `finalize-shadows.sh` script.
    ```bash
    ./Folia/scripts/finalize-shadows.sh
    ```
    This script will automatically:
    -   Copy your modified files from `shadow_workspace` to the correct location in the Folia source tree.
    -   Commit the changes in the internal Git repository used by Paperweight.
    -   Run `./gradlew rebuildPatches` to generate the final `.patch` file in `Folia/patches/server/`.

## 4. Core Development Rules

-   **Concurrency:** NEVER use static global lists without synchronization. NEVER access blocks or entities in a different chunk or region without using the appropriate scheduler.
-   **Scheduling:**
    -   ❌ **BAD:** `Bukkit.getScheduler().runTask(...)`
    -   ✅ **GOOD:** `entity.getScheduler().execute(...)` or `level.getRegionScheduler().execute(...)`
-   **Patching Strategy:** Keep vanilla file modifications small and targeted. Create new, complex logic in separate classes whenever possible and add simple "hooks" to the vanilla code.
