class_name BehindWallsPartyEffect
extends PartyEffect

#@export var effect_name: String = "Behind walls"
@export_file("*.tscn") var effect_path: String = \
	"res://Combat/Effects/AppliedEffects/Scenes/behind_walls.tscn"
@export var effect_args: int = 30

var effect: Dictionary:
	get: return {
			&"effect_name": effect_name,
			&"effect_path": effect_path,
			&"args": effect_args,
		}

func modify_unit_data(current_array: Array[UnitData]) -> void:
	if not party_parameters.this_party.inside_city: return
	for data in current_array:
		data.effects.append(effect)

func _apply_effect(...args: Array) -> void:
	party_parameters.this_party.units_container.units_requested.connect(modify_unit_data)
