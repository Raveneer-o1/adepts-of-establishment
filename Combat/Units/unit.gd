class_name Unit extends Node2D
	
var parameters: UnitParameters
var anim_handle: UnitAnimationsHandle
var party: Party

func initialize_variables() -> void:
	parameters = get_node("UnitParameters")
	party = get_parent() as Party
	if party == null:
		print_debug("Unable to find Party node!")

func _ready() -> void:
	initialize_variables()
