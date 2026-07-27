extends Control

const DUMMY_UNIT = preload("uid://bf28ttrgiypwi")
const BATTLE_SCENE = preload("uid://6lq6f06hma7")

@export var units: Array[StringName]

var _combat: CombatSystem

func _set_vars() -> void:
	GlobalDefs.set_testing_mode(GlobalDefs.TestingMode.Left)
	EventBus.left_controller = load("uid://0hcak5qcsv8i")
	EventBus.right_controller = load("uid://0hcak5qcsv8i")
	var i := -1
	for unit_name in units:
		i += 1
		if i >= Party.MAX_UNITS_NUMBER: break
		var data := UnitData.get_new(unit_name)
		if not data: continue
		data.party_position = i
		EventBus.left_units.append(data)

const DRAG_OVERLAY = preload("uid://bogotlbnkyeb7")

const SIZE = 43.0

func _create_overlay(spot: UnitSpot) -> void:
	var overlay: UnitTests_DragOverlay = DRAG_OVERLAY.instantiate()
	spot.add_child(overlay)
	overlay.this_spot = spot
	#overlay.global_position = spot.global_position
	#overlay.size = Party

func _ready() -> void:
	_set_vars()
	var combat_root := BATTLE_SCENE.instantiate()
	_combat = combat_root.find_child("Combat", false)
	add_child(combat_root)
	for spot in _combat.right_party.unit_spots:
		spot.add_unit(DUMMY_UNIT, null)
		#_create_overlay(spot)
	for spot in _combat.left_party.unit_spots:
		_create_overlay(spot)
	_combat.combat_logic.start_battle()
 
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("testing_pause"):
		_combat.process_mode = Node.PROCESS_MODE_PAUSABLE if \
			_combat.process_mode == Node.PROCESS_MODE_DISABLED else \
			Node.PROCESS_MODE_DISABLED
