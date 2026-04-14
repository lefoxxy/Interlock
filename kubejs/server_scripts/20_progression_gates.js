ServerEvents.recipes(event => {
  let progression = {
    remove: [],
    replacements: [],
    shaped: [],
    shapeless: []
  };

  try {
    progression = JsonIO.read('kubejs/data/interlock/pack/progression.json') ?? progression;
  } catch (error) {
    console.warn(`[interlock] Failed to read progression.json: ${error}`);
  }

  for (const removal of progression.remove) {
    event.remove(removal);
  }

  for (const replacement of progression.replacements) {
    event.replaceInput(
      replacement.filter ?? {},
      replacement.original,
      replacement.replacement
    );
  }

  for (const recipe of progression.shaped) {
    event.shaped(recipe.output, recipe.pattern, recipe.key).id(recipe.id);
  }

  for (const recipe of progression.shapeless) {
    event.shapeless(recipe.output, recipe.inputs).id(recipe.id);
  }
});
