# Change Workflow

Use this sequence for every pack change.

1. Write down the gameplay problem in one sentence.
2. Decide whether config alone can solve it.
3. If not, check whether tags or recipes can solve it.
4. If not, add the smallest KubeJS change that restores coherence.
5. Update quests only after the gameplay loop is stable.
6. Verify there is no new duplicate material path or progression skip.

Preferred order of operations:

- config
- tags
- recipe removal or replacement
- loot or worldgen tuning
- quests
