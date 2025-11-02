extends Node

## Unit type is used to determine default behavior in certain situations
enum UnitType{
	## When a melee unit assumes a defense stance, it automatically [i]shields[/i] (see [Unit])
	Melee,
	## Unit automatically adds [code]&"shot"[/code] tag to its attacks
	Archer,
	## No special effects
	Mage
}

## Defines the type of attack or damage, which determines synergies, 
## immunities, and other interactions.
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
	## and those that should not based on attack type.[/color]
	None
}
