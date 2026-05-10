class_name API_UIFilter
extends Node

@onready var this_api: FactionAPI = $".."

signal turn_end_clicked
signal hire_party(coords: Vector2i, _map: Map, hero: StringName)
signal hire_unit(unit_name: StringName, container: UnitsContainer)

signal research_upgrade(upgrade: FactionUpgrade)

signal show_hero_tree(hero: HeroData)

#func get_owner(parent: Node): MapFaction:
	#get:
		#var p := parent
		#while p:
			#if p is MapFaction: return p
			#if p is MapInteractableObject: return p.object_owner
			#p = p.get_parent()
		#return null
