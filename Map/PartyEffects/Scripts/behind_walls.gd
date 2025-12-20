class_name BehindWallsPartyEffect
extends PartyEffect

@export var effect_name: String = "Behind walls"
@export_file("*.tscn") var effect_path: String = \
	"res://Combat/Effects/AppliedEffects/Scenes/behind_walls.tscn"
@export var args: int = 30

var effect: Dictionary:
	get: return {
			&"effect_name": effect_name,
			&"effect_path": effect_path,
			&"args": args,
		}

func get_unit_data() -> void:
	if not party_parameters.this_party.inside_city: return
	var current_array: Array[UnitData] = party_parameters.accumulated_value \
		if party_parameters.accumulated_value is Array[UnitData] \
		else party_parameters.units
	current_array = current_array.duplicate(true)
	for data in current_array:
		data.effects.append(effect)
	party_parameters.accumulated_value = current_array

func _apply_effect() -> void:
	party_parameters.unit_data_requested.connect(get_unit_data)
