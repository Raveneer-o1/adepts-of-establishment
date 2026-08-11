class_name ResourceCost
extends RefCounted

var gold := 0
var stone := 0
var mana := 0

func _init(
	_gold: int = 0,
	_stone: int = 0,
	_mana: int = 0
) -> void:
	gold = _gold
	stone = _stone
	mana = _mana

## Returns if the costs are valid (i.e., non-negative)
func is_valid() -> bool:
	return \
		gold >= 0 and \
		stone >= 0 and \
		mana >= 0

## Creates a new [ResourceCost] from a dictionary. Expects the following exact keys:
## [code]&"gold"[/code], [code]&"stone"[/code], [code]&"mana"[/code].
## All other keys are ignored.
## Defaults to zero if any particular key is not present.
static func from_dict(d: Dictionary) -> ResourceCost:
	var _gold: int = d.get(&"gold", 0)
	var _stone: int = d.get(&"stone", 0)
	var _mana: int = d.get(&"mana", 0)
	return ResourceCost.new(_gold, _stone, _mana)
