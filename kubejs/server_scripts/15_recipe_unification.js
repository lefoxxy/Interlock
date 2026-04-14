ServerEvents.recipes(event => {
  let rules = { materials: [] };
  try {
    rules = JsonIO.read('kubejs/data/interlock/pack/unification.json') ?? rules;
  } catch (error) {
    console.warn(`[interlock] Failed to read unification.json: ${error}`);
  }

  for (let material of rules.materials) {
    for (let form of Object.values(material.forms ?? {})) {
      let canonical = form.canonical;
      let candidates = form.candidates ?? [];

      for (let candidate of candidates) {
        event.replaceInput({}, candidate, `#${form.tag}`);

        if (candidate !== canonical) {
          event.replaceOutput({}, candidate, canonical);
          event.remove({ output: candidate });
        }
      }
    }
  }
});
