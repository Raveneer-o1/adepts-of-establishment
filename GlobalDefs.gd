extends Node

# Defines the type of attack or damage, which determines synergies, 
# immunities, and other interactions.
enum AttackType {
	## Standard physical attacks used by most units
	Physical,
	## Elemental magic attacks used by spellcasting units
	Elemental,
	## Primarily used for debuffs and mental effects
	Mind,
	## Primarily used for healing and beneficial effects
	Life,
	## Bypasses all shields and immunities. [br]
	## [color=lightgreen]Note: [method Unit.finalize_attack] explicitly checks for None type 
	## when verifying immunities, but other systems rely on proper usage - the game cannot
	## automatically distinguish between attacks that should interact with game mechanics
	## and those that should not.[/color]
	None
}
