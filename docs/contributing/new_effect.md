# Adding New Unit Effects and Abilities

This guide walks you through the process of creating new abilities and effects for units using the **AppliedEffect** class system. Whether you're adding instant effects, triggered responses, or abilities, this documentation will help you implement them correctly.

The AppliedEffect system allows you to create modular unit abilities that can be applied during combat. Effects can range from simple stat modifications to complex triggered abilities that respond to game events.

### Creating the Effect Resource

1. **Create a new scene** in `res://Combat/Effects/AppliedEffects/Scenes/`.
   - Use a regular **Node** as the root type (do not use **AppliedEffect** directly, as this class is meant to be inherited)
   - Name both the scene file and the root node after your effect (e.g., `poison_effect.tscn` with root node named "PoisonEffect")

2. **Attach the script**:
   - Right-click the root node and select "Attach Script..."
   - Choose the appropriate template:
     - `Object: Applied Effect Template` for basic effects
     - `Object: Applied Effect Timed` for timed/duration-based effects
   - Name the script to match your effect (e.g., `poison_effect.gd`)
   - **Important**: Change the script save location to `res://Combat/Effects/AppliedEffects/Scripts/` (by default, scripts are saved in the scene directory)

3. **Implement your effect** by editing the generated script template.

### Configuring Parameters

The simplest effect is the one that modifies unit's parameters. This is done through a `ModifierStack` class.
In order to add your modifier, call `add_modifier()` on the parameters of your taget unit.
For example:
```gdscript
func _apply_effect(params: Variant) -> void:
	target_unit.parameters.add_modifier(
		&"evasion",        # this can be any parameter defined in add_modifier() documentation
		self,              # this helps to deactive mofiers when this effect is no longet valid
		increase_function  # this is a function that affect the values recieved after modification
	)
```

Implement the `_apply_effect()` method to define your effect's behavior. Here are two common patterns:

#### **Instantaneous Effect** (applies once and removes itself):
```gdscript
# Even if your effect does not need any parameters, always override this function
# with an explicitly empty body. This documents that the effect intentionally
# does not read parameters and you didn't just forget it.
func read_params(params: Variant) -> void:
	pass

func _apply_effect(params: Variant) -> void:
	# Perform the effect's action
	do_stuff()
	
	# Remove the effect after application
	queue_free()
```

#### **Triggered Effect** (responds to game events):
```gdscript
# Even if your effect does not need any parameters, always override this function
# with an explicitly empty body. This documents that the effect intentionally
# does not read parameters and you didn't just forget it.
func read_params(params: Variant) -> void:
	pass

# This function will be called when the specified signal is emmitted
# pay attention to the signature: it should match the signal's
func check_trigger(attack: Attack) -> void:
	# Always check if the effect is still valid
	if is_queued_for_deletion(): return
	
	# Check if this trigger should activate the effect
	if target_unit == attack.attacker:
		do_stuff()

func _apply_effect(params: Variant) -> void:
	# Register for game events using the signal mapping system
	# Don't connect signals manually - use this dictionary
	_signal_function_pairs[EventBus.attack_booked] = check_trigger
```

### Defining Effect Properties

Use exported variables to make your effect configurable in the editor. Always document their purpose:

```gdscript
## Determines the amount of damage dealt per turn
@export var damage_per_turn: int = 5

## The probability this effect will apply (0.0 to 1.0)
@export var application_chance: float = 1.0
```

### Additional notes

* Effects inherit several useful properties from the **AppliedEffect** base class:
	* `target_unit`: The unit to which this effect is applied (automatically set)
	* `color_start`, `color_end`, `color_effect`: Visual customization options (usage described in docstrings). *Note: these fields and not used by default, you need to implement it yourself for your effect*
	* `description`: The effect description shown to players (can be overridden with `_get_description()`)

* There are two ways to remove effects from units:
	* `lift_effect()` - The standard removal method:
		* Emits the `effect_lifted` signal
		* Calls `_remove_effect()`
		* Can be blocked by setting `liftable` to **false**
	* `queue_free()` - Removes the effect without the additional steps
		* The system is designed to handle effect objects being freed at any time
		* **Important:** Use `queue_free()` instead of regular `free()`

* After creating your effect, add the scene to a unit's **UnitParameters** node. This applies the effect to the unit and is how abilities are created.
