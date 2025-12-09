extends Node2D
class_name UnitSpot

## Represents a single position on the battlefield that can contain a unit.
##
## Each UnitSpot has a fixed battlefield position and may contain one [Unit].
## Includes a corpse container for storing fallen units as children and
## an Area2D with collision detection for handling mouse interactions.

var active: bool:
	get:
		return process_mode == PROCESS_MODE_DISABLED
	set(value):
		if not value:
			process_mode = PROCESS_MODE_DISABLED
		else:
			process_mode = PROCESS_MODE_INHERIT

var unit: Unit

var system: CombatSystem

var party_position: int

var party: Party


@onready var external_highlight: AnimatedSprite2D = get_node("ExternalHighlight")
@onready var area_2d: UnitArea = get_node("Area2D")

@onready var corpse_container: Node = $Corpses

func move_unit_to_graveyard() -> void:
	var u := unit
	if u == null:
		return
	remove_child(u)
	corpse_container.add_child(u)
	unit = null

## Highlights the unit externally.
func highlight_externally() -> void:
	external_highlight.visible = true


## Hides external highlight.
func reset_highlight() -> void:
	external_highlight.visible = false

func assign_unit(u: Unit) -> void:
	if not u: return
	if unit != null:
		push_error("Trying to assign unit (%s) to a spot that already has a unit (%s)!" % \
			[u.unit_name, unit.unit_name])
		return
	unit = u
	add_child(unit)
	unit.spot = self
	#unit.party_position = party_position
	#party.units[party_position] = unit
	unit.activate()

## Instantiates the provided [param loaded_unit] resource and assigns it to this spot. [br]
## [param data] can be set to [code]null[/code] and will be ignored.
func add_unit(loaded_unit: Resource, data: UnitData) -> Unit:
	if unit != null:
		push_error("Trying to add unit on top of already existing one!")
		return
	var u: Unit = loaded_unit.instantiate()
	if not u:
		push_error("Failed to instantiate unit scene!")
		return null
	assign_unit(u)
	if not unit:
		push_error("Unit is not assigned!")
		return null
	if not unit.initialize_variables(data):
		unit.queue_free()
		return null
	if u.is_queued_for_deletion():
		return null
	return u

func release_unit() -> void:
	if not unit:
		print_debug("Trying to release unit from empty spot!")
		return
	unit.party_position = -1
	unit.spot = null
	#party.units[party_position] = null
	remove_child(unit)
	unit = null

func click() -> void:
	EventBus.spot_clicked.emit(self)
