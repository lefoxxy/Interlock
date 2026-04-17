RecipeViewerEvents.removeEntries('item', event => {
  let rules = { materials: [] };
  try {
    rules = JsonIO.read('kubejs/data/interlock/pack/unification.json') ?? rules;
  } catch (error) {
    console.warn(`[interlock] Failed to read unification.json: ${error}`);
  }

  const hidden = [];

  for (const material of rules.materials) {
    for (const form of Object.values(material.forms ?? {})) {
      for (const candidate of form.candidates ?? []) {
        if (candidate !== form.canonical) {
          hidden.push(candidate);
        }
      }
    }
  }

  for (const itemId of hidden) {
    event.remove(itemId);
  }
});
