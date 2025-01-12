extends Node2D
class_name UnitSpot

var active: bool:
	get:
		return process_mode == PROCESS_MODE_DISABLED
	set(value):
		if not value:
			process_mode = PROCESS_MODE_DISABLED
		else:
			process_mode = PROCESS_MODE_INHERIT

var _unit: Unit
var unit: Unit:
	get:
		if is_instance_valid(_unit):
			return _unit
		return null
	set(value):
		_unit = value

var system: CombatSystem

var party_position: int

var party: Party


@onready var external_highlight: AnimatedSprite2D = get_node("ExternalHighlight")
@onready var area_2d: UnitArea = get_node("Area2D")

@onready var corpse_container: Node = $Corpses

func move_unit_to_graveyard() -> void:
	var u := unit
	remove_child(u)
	corpse_container.add_child(u)
	unit = null

## Highlights the unit externally.
func highlight_externally() -> void:
	external_highlight.visible = true


## Hides external highlight.
func reset_highlight() -> void:
	external_highlight.visible = false


func add_unit(loaded_unit: Resource) -> void:
	if unit != null:
		print_debug("Trying to add unit on top of already existing one!")
		return
	unit = loaded_unit.instantiate()
	add_child(unit)
	unit.initialize_variables()
	unit.party_position = party_position
	party.units[party_position] = unit
	return

func click() -> void:
	EventBus.spot_clicked.emit(self)
