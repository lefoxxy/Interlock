# CurseForge Workflow

Interlock should be maintained as a CurseForge modpack project, not as a custom installer.

## Source-Control Rules

Commit these:

- `config/`
- `defaultconfigs/`
- `kubejs/`
- `quests/`
- `meta/`
- docs and pack notes

Do not commit these:

- downloaded mod jars
- local launcher instance files
- temporary server runtimes
- exported zip files unless you intentionally want a release artifact in source control

## Authoring Loop

1. Build or update the pack profile in the CurseForge app.
2. Launch locally and let configs generate.
3. Copy the generated configs or quest data you want to keep back into this repository.
4. Tune recipes, tags, scripts, and quests here.
5. Re-export from CurseForge for distribution testing.

## Version Tracking

`meta/installed-mods.json` is the current validated reference list for the pack's resolved mod set and versions.

Treat it as a lock reference for rebuilding the CurseForge profile, not as a jar distribution manifest.
