class_name MapItem
extends Node

## Base class for all items like potions, scrolls, equipment, etc.
##
## This class can be inherited and extended to create more complex behavior.
## Base class allows to create only valuables
## (items for selling that don't have any effect).
## See [ConsumableMapItem] implementation as an example of [MapItem] extention

@export var item_name: String
@export_file_path("*.*") var image_path: String
@export_multiline var description: String
@export var base_cost: int = 0

var ui_manager: PartyUIManager

func can_be_applied_to(where: Variant) -> bool:
	return false

func apply_to(where: Variant) -> void:
	pass
