class_name MapWorker
extends Node

@onready var map: Map = $".."
@onready var visualizer: MapVisualizer = $"../Visualizer"

var active_party: MapParty:
	get: return map.active_party
var event_handler: MapEventHandler:
	get: return map.event_handler
var game: GameMap:
	get: return map.game

func do_combat(attacker: MapParty, defender: MapParty) -> void:
	_prefill_data(attacker, defender)
	
	attacker.face_tile(defender.tile_position)
	defender.face_tile(attacker.tile_position)
	
	var battle := _load_battle(attacker, defender)
	await _play_effect(defender.global_position)
	
	await _switch_to_battle(battle)
	attacker.update_parameters()
	defender.update_parameters()

func _prefill_data(attacker: MapParty, defender: MapParty) -> void:
	EventBus.left_units = attacker.parameters.get_unit_data()
	EventBus.right_units = defender.parameters.get_unit_data()
	EventBus.left_controller = load(GlobalDefs.get_controller(attacker.faction.controller))
	EventBus.right_controller = load(GlobalDefs.get_controller(defender.faction.controller))

func _load_battle(attacker: MapParty, defender: MapParty) -> Node:
	var battle: Control = map.battle_scene.instantiate()
	battle.process_mode = Node.PROCESS_MODE_ALWAYS
	battle.hide()
	
	# combat starts here because this is when combat scene enters
	# the tree and _ready() is called
	map.add_sibling(battle)
	return battle

const battle_effect = preload("res://Map/Scenes/visual_effect.tscn")

func _switch_to_battle(battle: Control) -> void:
	(battle.find_child("Camera2D", false) as Camera2D).make_current()
	
	battle.show()
	game.ui_layers.switch_to(&"Battle")
	process_mode = Node.PROCESS_MODE_DISABLED
	
	await EventBus.battle_ended
	game.ui_layers.switch_to(&"Main")
	battle.queue_free()
	process_mode = Node.PROCESS_MODE_PAUSABLE
	map.camera.make_current()

func _play_effect(pos: Vector2) -> void:
	var effect := battle_effect.instantiate() as TemporaryEffect
	add_child(effect)
	effect.global_position = pos
	await effect.effect_finished


func move_active_party_to_object(object: MapInteractableObject) -> void:
	if active_party.is_moving:
		active_party.control.abort_moving()
		return
	var path := visualizer.get_highlighted_tiles()
	if not path:
		visualizer.reset_highlights()
		return
	await active_party.control.walk_along_path(
		path,
		true,
		object
	)
	visualizer.reset_highlights()
	map.clean_hashtable()
	var cost := object.validate_and_interact(active_party)
	if cost > 0: active_party.parameters.subtract_mp(cost)

func move_active_party(coords: Vector2i) -> void:
	if active_party.is_moving:
		active_party.control.abort_moving()
		return
	var path := visualizer.get_highlighted_tiles()
	if not path:
		visualizer.reset_highlights()
		return
	await active_party.control.walk_along_path(path)
	visualizer.reset_highlights()
	
	# moving party creates an empty entry for each tile that party walked over
	map.clean_hashtable()
