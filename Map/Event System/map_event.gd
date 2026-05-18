@abstract
class_name MapEvent
extends Node

@abstract func invoke() -> void

# TODO: Reset the map_variables list at the start of each game/mission.
## Stores a list of in-game variables that can be modified by
## events and checked by both events and triggers. [br]
## [b]Note:[/b] Although events are attached to a specific [Map] node and only affect
## that map, these variables are global to the entire level. They are reset
## at the start of a new mission but persist across different maps within the same level.
static var map_variables: Dictionary[StringName, int]
