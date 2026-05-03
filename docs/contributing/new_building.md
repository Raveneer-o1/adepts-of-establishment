# Adding New Buildings to a Faction

Adding buildings is required to create faction-wide upgrade trees. This includes (but is not limited to) unit evolution trees.

In order to function properly, each building needs two main components: the actual upgrade object and its UI representation.

## Creating the Upgrade Object

The upgrade objects are represented by **FactionUpgrade** nodes inside a tree structure. The scenes containing said structures are located in:
`res://Map/Scenes/Buildings/EvolutionBuildings/`

> *Note: The folder and corresponding classes are called "Evolution" for legacy reasons, from an earlier version of the game where buildings were meant only to represent unit evolution. Now term "Evolution" usually refers to unit evolution.*

Choose the tree where you want to add your building, then add your **FactionUpgrade** node in the appropriate place. The tree structure represents progression:

- Nodes added as **children** of other nodes have their parents as **prerequisites**.
- Nodes added directly to the **tree root** are available from the start (no prerequisites).

If you do **not** add your building to the tree, the player won't be able to research it through normal gameplay. However, it will still be possible to add your building to the list of active upgrades via scripts.

## Creating the UI Representation

Your building will function even without a custom UI — the game will automatically add it to the list of available upgrades, and the player can select and build it from there. However, this generic list can become unwieldy, as it may contain dozens of entries. For a better player experience, you should add a proper UI representation that groups your building with others and positions it correctly on screen.

To do this, modify the **UI_DefaultCapitalLayout** scene located in:
`res://UI/DefaultCapitalLayout/`

The logic is straightforward:

1. Build the UI so it is intuitively clear.
2. Have the text on the node (an instance of **UI_DefaultCapitalLayout_Node**) **match your building's name exactly**.

> **Important:** The text on the node must match your building's name exactly. Otherwise, the automatic system will not be able to connect the UI to the upgrade.

## Designing the Upgrade Itself

The upgrade is a class that affects the entire faction. Unfortunately, there is currently no generic system that can handle any effect automatically — everything must be coded manually.

For example, if you want your upgrade to increase the attack of all archers, you will need to manually add effects to all existing and future parties.

Standard way to implement such effects would be to create a `PartyEffectFromBuilding` class (see `PartyEffectFromItem` as an example).
