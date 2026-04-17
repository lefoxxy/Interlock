# Interlock

Interlock is a NeoForge 1.21.1 industrial modpack built to feel engineered, not assembled.

This is not a kitchen-sink tech pile where five mods solve the same problem and the fastest route wins. Interlock is about building a factory that earns every upgrade. Power starts physical. Logistics start visible. Storage starts constrained. As the pack opens up, your base stops being a workshop and becomes a connected industrial system.

If you like modpacks where progression has weight, infrastructure matters, and every new layer makes the whole factory more capable, Interlock is built for you.

## What Makes It Different

- One factory, not five competing tech trees
- Clear progression through `Immersive Engineering`, `Mekanism`, `Industrial Foregoing`, `Powah`, and `AE2`
- Unified materials and cleaned-up recipes so the pack feels coherent
- Early-game physical logistics before late-game digital control
- Automation that is earned through engineering, not handed out immediately
- Decorative and building support chosen to reinforce an industrial, grounded look

## The Interlock Loop

You begin by building a real workshop: storage that makes sense, routed materials, early power, and machine lines you can actually read. `Immersive Engineering` establishes the floor plan and the feel of the base. `Mekanism` takes over as the processing backbone. `Industrial Foregoing` arrives later as a true automation layer once you have the power, plastic, and machine infrastructure to support it. `AE2` is the late-game control system, not an early escape hatch.

The result is a pack about throughput, stability, and systems design. If a line stalls, you improve it. If the grid buckles, you expand it. If the factory sprawls, you redesign it. Progress comes from engineering decisions, not luck.

## Pack Pillars

- `Progression with intent`: new systems unlock because your factory is ready for them
- `Meaningful logistics`: `Pipez` matters early, AE2 matters late
- `Power that scales`: early IE, mid-game `Powah` and `Mekanism`, heavier late-game demand
- `Automation with boundaries`: `Industrial Foregoing` supports the factory instead of replacing the pack
- `Curated identity`: config, KubeJS, gating, and quest structure matter more than raw mod count

## Built for CurseForge

This repository is authored for CurseForge distribution.

- It tracks configs, KubeJS scripts, quests, metadata, and pack structure
- It does not require a custom installer or custom launcher
- CurseForge export files should be generated from the CurseForge app when publishing
- Downloaded mod jars and temporary runtime files are local validation artifacts and should not be committed unless intentionally tracked

## Repository Layout

- `meta/` stores pack metadata, lockfiles, and progression references
- `docs/` stores design notes, workflow, and curation rules
- `config/` stores checked-in config overrides
- `defaultconfigs/` stores new-world defaults
- `kubejs/` stores progression, unification, and integration logic
- `quests/` stores quest planning and related authoring files
- `mods/` stores launcher-facing notes and export-related metadata
- `scripts/` stores local validation and generation helpers

## Design Rules

- Prefer configuration before scripting
- Prefer scripting before custom content
- Prefer one shared material identity per resource
- Prefer progression gates that reinforce infrastructure
- Reject overlapping systems that flatten the pack
- Keep the tone industrial, grounded, and systems-focused

## Current Direction

Interlock is being shaped into a premium factory pack with:

- strong progression
- unified resources
- meaningful logistics
- curated automation
- a full FTB Quests progression arc
- enough decoration to make industrial builds feel intentional instead of bare

## Next Steps

1. Maintain the validated CurseForge profile from `meta/installed-mods.json`
2. Keep refining the questbook flow and chapter presentation
3. Continue tightening recipes, materials, and progression overlap
4. Export CurseForge release candidates from the app when publishing
