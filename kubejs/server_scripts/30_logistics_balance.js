ServerEvents.recipes(event => {
  let logistics = {
    lateGameRecipeIds: []
  };

  try {
    logistics = JsonIO.read('kubejs/data/interlock/pack/logistics.json') ?? logistics;
  } catch (error) {
    console.warn(`[interlock] Failed to read logistics.json: ${error}`);
  }

  for (const recipeId of logistics.lateGameRecipeIds) {
    event.remove({ id: recipeId });
  }
});
