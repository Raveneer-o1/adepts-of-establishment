extends Control

const DUMMY_UNIT = preload("uid://bf28ttrgiypwi")
const BATTLE_SCENE = preload("uid://6lq6f06hma7")

@export var unit_name: StringName

var _combat: CombatSystem

func _set_vars() -> void:
	GlobalDefs.set_testing_mode(GlobalDefs.TestingMode.Left)
	EventBus.left_controller = load("uid://0hcak5qcsv8i")
	EventBus.right_controller = load("uid://0hcak5qcsv8i")
	var data := UnitData.get_new(unit_name)
	if not data: 
		_combat.free()
		get_tree().quit()
		return
	data.party_position = 2
	EventBus.left_units.append(data)

func _ready() -> void:
	_set_vars()
	var combat_root := BATTLE_SCENE.instantiate()
	_combat = combat_root.find_child("Combat", false)
	add_child(combat_root)
	#await _combat.ready
	for spot in _combat.right_party.unit_spots:
		spot.add_unit(DUMMY_UNIT, null)
	_combat.combat_logic.battle_in_progress = true
	_combat.win_label.visible = false
	_combat.combat_logic.start_battle()
