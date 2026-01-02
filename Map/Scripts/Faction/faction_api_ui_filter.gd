class_name API_UIFilter
extends Node

@onready var this_api: FactionAPI = $".."

signal turn_end_clicked
signal hire_party(coords: Vector2i, _map: Map, hero: StringName)
signal hire_unit()
