# Interlock

Interlock is a NeoForge 1.21.1 XL tech modpack built around seamless integration.

The goal is a premium industrial sandbox with:

- strong progression
- unified resources
- meaningful logistics
- minimal custom content
- coherence over raw mod count

Interlock is curated first through configuration, recipe scripting, tag cleanup, balance tuning, and quest structure. New mechanics should be rare. The pack should feel like one connected ecosystem instead of several overlapping tech packs sharing the same instance.

This repository is authored for CurseForge distribution.

- The repo tracks pack content, configs, KubeJS scripts, quests, and pack metadata.
- The repo does not need a custom installer or custom launcher.
- CurseForge export files should be generated from the CurseForge app when publishing or testing pack imports.
- Downloaded mod jars and temporary runtime files are local validation artifacts and should not be committed.

## Repository Layout

- `meta/` stores pack runtime and progression policy
- `docs/` stores curation rules and maintenance workflow
- `config/` stores checked-in config overrides
- `defaultconfigs/` stores new-world defaults
- `kubejs/` stores integration scripts and pack data
- `quests/` stores quest exports once a questing mod is selected
- `mods/` stores launcher-facing notes and any non-jar metadata needed for export workflow

## Design Rules

- Prefer configuration before scripting
- Prefer scripting before custom content
- Prefer tag cleanup before duplicate material chains
- Prefer one shared resource identity per material
- Prefer progression gates that reinforce logistics and infrastructure
- Reject mods that create disconnected parallel progression

## Next Steps

1. Create and maintain the pack profile in the CurseForge app using the validated version set in `meta/installed-mods.json`
2. Export a CurseForge manifest when you want to distribute or archive a release candidate
3. Define real unification mappings in `kubejs/data/interlock/pack/unification.json`
4. Add recipe and progression gates in `kubejs/data/interlock/pack/progression.json`
5. Turn `meta/quest-outline.toml` into real quest chapters once the questing mod is chosen
