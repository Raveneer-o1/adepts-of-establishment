class_name UnitTests_Root
extends CanvasLayer

const DUMMY_UNIT = preload("uid://bf28ttrgiypwi")
const BATTLE_SCENE = preload("uid://6lq6f06hma7")
const DRAG_OVERLAY = preload("uid://bogotlbnkyeb7")

@export var units: Array[StringName]
@onready var unit_tests_item_list: ItemList = %UnitTests_ItemList

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


func _create_overlay(spot: UnitSpot) -> void:
	var overlay: UnitTests_DragOverlay = DRAG_OVERLAY.instantiate()
	spot.add_child(overlay)
	overlay.this_spot = spot

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

func add_unit(unit_name: String, pos: int = -1) -> void:
	var data := UnitData.get_new(unit_name)
	assert(data)
	if pos < 0:
		for i in range(Party.MAX_UNITS_NUMBER):
			if _combat.left_party.unit_spots[i].unit: continue
			if data.large_unit:
				if i == 0 or i >= Party.MAX_UNITS_NUMBER: continue
				if _combat.left_party.unit_spots[i - 1].unit: continue
				if _combat.left_party.unit_spots[i + 1].unit: continue
			pos = i
			break
	if pos < 0:
		push_warning("Unable to place a unit")
		return
	data.party_position = pos
	_combat.load_single_unit(data)
	_combat.left_party.place_unit(data)

func next_unit() -> void:
	_is_first_unit = false
	for unit_name: StringName in GlobalDefs.units_database.database.keys():
		_clear_party()
		add_unit(unit_name, 3)
		await _next_unit_pressed

func _clear_party() -> void:
	for unit in _combat.left_party.all_units:
		if not is_instance_valid(unit): continue
		unit.deactivate()
		unit.queue_free()

signal _next_unit_pressed

var _is_first_unit := true

func _on_next_unit_button_pressed() -> void:
	if _is_first_unit: next_unit()
	else: _next_unit_pressed.emit()
	if not _combat.combat_logic.battle_in_progress:
		_combat.combat_logic.start_battle()


func _on_left_random_bias_check_button_toggled(toggled_on: bool) -> void:
	GlobalDefs.set_testing_mode(
		GlobalDefs.TestingMode.Left if toggled_on \
		else GlobalDefs.TestingMode.Right
	)
