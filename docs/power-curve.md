# Power Curve

Current intended power curve:

- Early power: `Immersive Engineering` only
- Mid power: `Powah` + `Mekanism`
- Late power: high-tier `Powah`, large storage, and heavy automation load

## Current Config Changes

Industrial Foregoing:
- raised the entry-chain energy cost for `fluid_extractor` and `latex_processing_unit`
- raised automation energy costs for farm, mob, and fluid machines
- raised internal buffers so the machines are still usable once the player reaches mid-game power

Mekanism:
- increased the cost of core processing machines from the default early-game range into a firmer mid-game range
- increased advanced chemical processing costs more sharply than basic ore processing

Powah:
- reduced `starter` and `basic` generator output so they do not invalidate `Immersive Engineering`
- kept `hardened` and `blazing` as the practical mid-game bridge
- kept `niotic`, `spirited`, and `nitro` as the real late-game power backbone
- increased the global energizing cost multiplier so the tier climb carries more weight

## Design Outcome

- `Immersive Engineering` remains the practical early power solution
- early `Powah` is now supplementary rather than dominant
- `Industrial Foregoing` machines are expensive enough that they are not efficient on a small starter grid
- `Powah` now fills the intended mid-game power role and scales into late-game support
- `Mekanism` now asks for more serious power planning before its machine suite feels comfortable at scale
