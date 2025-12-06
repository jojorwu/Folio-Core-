# Folio Project Instructions for Jules

## Project Structure
This is a Minecraft Server Core fork based on Paper/Folia using the "Paperweight" build system.
- **Do not edit `.patch` files manually.**
- **Source Code:** The actual Minecraft source code is NOT in the repo. It is generated dynamically.
- **Workflow:** You must edit the Java files in `folio-server/src/main/java` OR the generated vanilla files in `folio-server/src/minecraft/java/`.

## How to make changes (The Rebuild Workflow)
1. **Setup:** Always run `./scripts/setup-jules.sh` at the start of a session to generate the vanilla source code.
2. **Locate:** The vanilla source code for editing will be located at `folio-server/src/minecraft/java/`. **IMPORTANT: Do NOT edit files in `build/` directories, as Gradle will ignore them when creating patches.**
3. **Edit:**
   - If adding a NEW feature: Create a new class in `folio-server/src/main/java/net/folio/`.
   - If modifying Vanilla logic: Modify the Java file in the `src/minecraft/java` folder directly.
4. **Save:** After modifying the vanilla files, run `./gradlew rebuildPatches`. This will automatically generate the `.patch` files in `patches/`.
5. **Commit:** You only commit the new `.patch` files and your new `src/` files. Never commit the `build/` folder.

## Key Rules
- Prefer **Logic Injection**: Create a new class for complex logic and add a simple 1-line hook into the vanilla class.
- If a method signature changes, check `mappings` (Mojang mappings are used).
