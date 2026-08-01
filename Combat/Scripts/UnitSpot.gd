extends Node2D
class_name UnitSpot

## Represents a single position on the battlefield that can contain a unit.
##
## Each UnitSpot has a fixed battlefield position and may contain one [Unit].
## Includes a corpse container for storing fallen units as children and
## an Area2D with collision detection for handling mouse interactions.

## Whether this [UnitSpot] is currently being processed. Setting this to [code]false[/code]
## disables both node processing and game logic related to this spot. [br]
## [b]Note:[/b] This is the same as [member active], but returns the correct value.
var is_active: bool:
	get:
		return process_mode != PROCESS_MODE_DISABLED
	set(value):
		if not value:
			process_mode = PROCESS_MODE_DISABLED
		else:
			process_mode = PROCESS_MODE_INHERIT

# NOTE: This field is not removed due to the large number of potential dependencies.
# A search for "active" currently returns 251 matches across files (not all are variables).
# This should be used only during initialization, primarily to block spots occupied
# by large units... but who knows what else may rely on it.
## There is an error in the implementation: when reading this value,
## it returns the opposite; writing works correctly.
## Use [member is_active] for correct behavior.
## @deprecated: use [member is_active] instead.
var active: bool:
	get:
		push_warning("Deprecated usage")
		return process_mode == PROCESS_MODE_DISABLED
	set(value):
		push_warning("Deprecated usage")
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

## Reparents the [member unit] to a graveyard.
## This should not be called directly, as it does not deactivate the unit.
## Use [method Unit.die] for proper death processing.
func move_unit_to_graveyard() -> void:
	if not unit: return
	assert(unit.get_parent() == self, "Invalid unit parent")
	unit.reparent(corpse_container)
	unit = null

## Highlights the unit externally.
func highlight_externally() -> void:
	external_highlight.visible = true


## Hides external highlight.
func reset_highlight() -> void:
	external_highlight.visible = false

## Places the specified [param u] at this spot.
## The spot must be empty ([member unit] must be [code]null[/code]) and
## the provided unit must not already be a child of any node.
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

## Removes the [member unit] from this spot.[br][br]
## The unit becomes an orphan — you must store a reference to it
## [b]before[/b] calling this method. [br]
## Caution: If this was the last unit in the game or the party, removing it
## may trigger battle end and cause memory leaks.
func release_unit() -> void:
	if not unit:
		print_debug("Trying to release unit from empty spot!")
		return
	if not is_active: return
	if unit.parameters.large_unit:
		unit.party.unit_spots[unit.party_position - 1].is_active = true
		unit.party.unit_spots[unit.party_position - 1].unit = null
		unit.party.unit_spots[unit.party_position + 1].is_active = true
		unit.party.unit_spots[unit.party_position + 1].unit = null
		position = unit.party.get_unit_position(party_position)
	unit.party_position = -1
	unit.spot = null
	#party.units[party_position] = null
	remove_child(unit)
	unit = null

func click() -> void:
	EventBus.spot_clicked.emit(self)

func question_start_react(data: UnitData) -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if unit and unit.original_data == data:
		highlight_externally()
	else: reset_highlight()

func question_end_react(data: UnitData) -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	if unit and unit.original_data == data:
		reset_highlight()

func _ready() -> void:
	EventBus.unit_question_started.connect(question_start_react)
	EventBus.unit_question_ended.connect(question_end_react)
