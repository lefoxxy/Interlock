ServerEvents.tags('item', event => {
  let rules = { materials: [] };
  try {
    rules = JsonIO.read('kubejs/data/interlock/pack/unification.json') ?? rules;
  } catch (error) {
    console.warn(`[interlock] Failed to read unification.json: ${error}`);
  }
  let contractCount = 0;
  let duplicateCount = 0;

  for (let material of rules.materials) {
    for (let [formName, form] of Object.entries(material.forms ?? {})) {
      event.add(form.tag, form.candidates ?? []);
      contractCount++;

      let members = Ingredient.of(`#${form.tag}`).itemIds ?? [];
      if (members.length > 1) {
        duplicateCount++;
        console.info(
          `[interlock] Duplicate ${formName} entries for ${material.name}: ${members.join(', ')} -> canonical ${form.canonical}`
        );
      }

      if (members.length <= 1) {
        console.info(
          `[interlock] ${material.name} ${formName} resolved to ${form.canonical}`
        );
      }
    }
  }

  console.info(`[interlock] Loaded ${contractCount} item tag contracts`);
  console.info(`[interlock] Found ${duplicateCount} duplicate tag groups`);
});
