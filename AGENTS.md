# Agent Instructions for Folia Development

This document provides essential instructions for AI agents working on this Folia project. Adhering to these guidelines is critical for success.

## 1. Project Architecture

This is a fork of **Folia** (from PaperMC), which uses a **Regionized Multithreading** architecture. Standard Spigot/Bukkit coding practices are **unsafe** and will cause server crashes. You must always write thread-safe code.

## 2. Initial Workspace Setup

At the beginning of any task, you **must** set up your workspace to generate the necessary Minecraft source code. The vanilla source code is not stored in the repository.

Run the following command from the repository root:
```bash
cd Folia && ./scripts/setup-jules.sh
```
This script configures Git and runs `./gradlew applyPatches`, which prepares the source code for you to edit.

The editable vanilla source code is located at: `Folia/folia-server/src/minecraft/java/`

## 3. Creating Patches (IMPORTANT)

Creating patches in this project is a **manual process**. The standard `./gradlew rebuildPatches` command is unreliable and should not be used.

**To create a patch, you must create a new patch file manually in the `Folia/patches/server/` directory.**

### Workflow:
1.  Make your code changes to the relevant file inside `Folia/folia-server/src/minecraft/java/`.
2.  Manually create a new `.patch` file (e.g., `0004-My-New-Fix.patch`) in the `Folia/patches/server/` directory.
3.  Format the patch file using the standard `git diff` format. You can use an existing patch as a template. The build system is tolerant of placeholder hashes (e.g., `index 1234567..89abcdef`), so you don't need to calculate them.

## 4. Core Development Rules

-   **Concurrency:** NEVER use static global lists without synchronization. NEVER access blocks or entities in a different chunk or region without using the appropriate scheduler.
-   **Scheduling:**
    -   ❌ **BAD:** `Bukkit.getScheduler().runTask(...)`
    -   ✅ **GOOD:** `entity.getScheduler().execute(...)` or `level.getRegionScheduler().execute(...)`
-   **Patching Strategy:** Keep vanilla file modifications small and targeted. Create new, complex logic in separate classes whenever possible and add simple "hooks" to the vanilla code.
