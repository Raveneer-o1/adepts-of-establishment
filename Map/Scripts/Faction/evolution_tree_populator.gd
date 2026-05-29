class_name EvolutionTreePopulator
extends CanvasLayer

## Predefined scene for the [b]Empire[/b] evolution tree
@export_file_path("*.tscn") var empire_path: String
## Predefined scene for the [b]Necropolis[/b] evolution tree
@export_file_path("*.tscn") var necropolis_path: String

var evolution_buildings: Node = null

const EVOLUTION_BUILDINGS_NODE_NAME = "EvolutionBuildings"

func _get_path(faction: GlobalDefs.Faction) -> String:
	match faction:
		GlobalDefs.Faction.Empire: return empire_path
		GlobalDefs.Faction.Necropolis: return necropolis_path
	return ""

func _populate(path: String) -> void:
	if not path: return
	if not FileAccess.file_exists(path):
		push_error("File '%s' does not exist" % path)
		return
	
	var resource: PackedScene = load(path)
	if not resource:
		push_error("Failed to load '%s'" % path)
		return
	
	if not evolution_buildings:
		evolution_buildings = find_child(EVOLUTION_BUILDINGS_NODE_NAME, false, false)
	var new_node := resource.instantiate()
	add_child(new_node)
	
	if not evolution_buildings:
		evolution_buildings = new_node
		new_node.name = EVOLUTION_BUILDINGS_NODE_NAME
		return
	
	for c in new_node.get_children():
		c.reparent(evolution_buildings)
	new_node.queue_free()

func _remove_duplicates() -> void:
	var children := get_children()
	var researched_upgrades := {}
	for u: FactionUpgrade in get_parent().get_all_upgrades(true):
		researched_upgrades[u.upgrade_name] = null
	while children:
		var c: Node = children.pop_front()
		children.append_array(c.get_children())
		if c is not FactionUpgrade: continue
		if (c as FactionUpgrade).upgrade_name in researched_upgrades:
			c.queue_free()
			for cc in c.get_children():
				cc.reparent(c.get_parent())

func _ready() -> void:
	var faction: MapFaction = get_parent()
	if not faction:
		queue_free()
		return
	_populate( _get_path(faction.base_faction) )
	_remove_duplicates.call_deferred()
