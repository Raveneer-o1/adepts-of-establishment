# Adding New Units

This guide is designed for beginner-level developers who are new to the project's codebase. It explains the process for introducing a new unit into the game. 

## Adding the Unit

1. Place your animation spritesheets in `res://Arts/<Faction>/` (e.g., `res://Arts/EmpireUnits/`).
2. Create an inherited scene from the parent unit scene `res://Combat/Units/unit.tscn`.
3. Save the new scene to `res://Combat/Units/DerivedUnits/<Faction>/` with your unit's name.

**Note:** The game identifies and distinguishes units by their internal name, so every unit you create must have a completely unique name.

To maintain consistency and prevent errors, please adhere to the following naming convention:
*   Use `snake_case` for all unit names (e.g., `goblin_shaman`, `pirate_captain`).
*   Avoid using capital letters within the name.

*At the moment, not all existing units follow this pattern. For reference, please use the units located in the `res://Combat/Units/Derived units/Neutral/` folder as a consistent example to follow.*

## Configuring the Unit

### Root Node Parameters
Set `Unit Name`, `Unit Type`, `Faction`, and description

### AnimationHandle Node
1. Create a new SpriteFrames resource
2. Add animations with these exact names (case-sensitive):
| Animation             | Exact Name |
| --------------------- | ---------- |
| Idle                  | `default`  |
| Attacking             | `attack`   |
| Alternative attacking | `attack2`  |
| Taking damage         | `damage`   |
| Healing               | `heal`     |

	You don't have to have all these implemented: missing animations will use defaults from the **AnimationPlayer** node

3. Enable autoplay for the `default` (idle) animation
4. Disable looping for all other animations
5. Set the **Frames to Emit** list. The list should contain the frame numbers from your attack animation where the weapon makes contact or the projectile would be launched - the exact moments when the attack's impact occurs
6. **Attack Sound Frame** is the frame where sound is played. Is should by syncronized with [sound](#adding_sounds)
7. Set the offset value so that the unit is placed at the center

### UnitParameters Node
1. Configure basic parameters:
	1. *Level*
	2. *BaseParameters* resource
	3. *Large* Unit flag
	4. *Underlying Immunities* list
	5. *Attack Effect* (if needed)
	6. *Other Effects*
2. Add **UnitAttack** nodes for each attack the unit needs (see the class documentation).
Don't forget to add the *Target Validation* resource (located at `res://Combat/Units/Parameters/Validation/`)
3. Add effects and abilities by instantiating scenes from `res://Combat/Effects/AppliedEffects/Scenes/`. If you want to create a new effect, refer to the [guide](new_unit.md)

## Adding Sounds

The **SoundPlayer** node contains categorized containers for different events. Add your sound files as children to the appropriate nodes:
* Attack sounds to the `Attack` node
* Damage sounds to the `Damage` node
* etc.

You can add multiple sounds to each container for variety - the system will randomize selection.

## Adding the Unit to the Menu

To make your new unit available for selection in the game's menu, you need to add it to the appropriate list.

1. Open the main menu scene: `res://Menu/Scenes/menu.tscn`
2. Navigate to this path in the scene tree:
   ```
   MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer4/NinePatchRect/MarginContainer/TabContainer
   ```
   This TabContainer organizes all available units by faction.
3. Find the tab corresponding to your unit's faction.
4. Within that faction tab, locate the appropriate unit type category.
5. Instantiate a `tree_item_unit` node as a child of the correct unit type.
6. Configure the new node:
   * Rename it to match your unit's name
   * Set the **Unit Name** parameter to your unit's display name
   * Set the **Path** parameter to point to your unit's scene file

*Example Configurations:*
| Unit Name | Path |
| --------- | ---- |
| Vampire   | `res://Combat/Units/Derived units/Undead/u13_vampire.tscn` |
| Royal cavalier | `res://Combat/Units/Derived units/Empire/e11 Royal Cavalier.tscn` |
