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

static func from_dict(d: Dictionary) -> ResourceCost:
	var _gold: int = d.get(&"gold", 1)
	var _stone: int = d.get(&"gold", 0)
	var _mana: int = d.get(&"gold", 0)
	return ResourceCost.new(_gold, _stone, _mana)
