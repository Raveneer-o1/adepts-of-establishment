class_name MapItem
extends Node

## Base class for all items including potions, scrolls, equipment, etc.
##
## Inherit and extend this class to implement complex item behaviors.
## The base class supports only valuables (sellable items without special effects).
## See [ConsumableMapItem] for an example of extended functionality.
## [br][br]
## [b]Important:[/b] This class is designed for high mobility - [MapItem] nodes
## frequently change parent nodes without centralized tracking.
## This means two things:[br]
## 1. Transfer items by simply calling [method Node.reparent] -
## containers automatically scan children to find items.[br]
## 2. Do not store [MapItem] references to track inventory contents - these
## references remain valid after movement but point to items in different containers.[br]
## Additional rationale against storing references: Items can be destroyed
## (e.g., through consumption), and the game provides no mechanism to track
## and clean up external references to invalidated items.

@export var item_name: String
@export_file_path("*.*") var image_path: String
@export var base_cost: int = 0
@export_multiline var description: String

var item_owner: MapParty:
	get:
		var parent := get_parent()
		while parent:
			#if parent is PartyInventory: return parent.get_parent()
			if parent is MapParty: return parent
			if parent is Map: return null
			parent = parent.get_parent()
		return null

signal item_moved(old_owner: Node)

var ui_manager: PartyUIManager

func get_description() -> String:
	return description

func can_be_applied_to(where: Variant) -> bool:
	return false

func apply_to(where: Variant) -> void:
	pass
