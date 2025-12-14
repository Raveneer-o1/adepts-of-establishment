class_name PartyInventory
extends Node

var items: Array[MapItem]:
	get:
		var res: Array[MapItem] = []
		for c in get_children():
			if c is MapItem: res.append(c)
		return res

func has_specific_item(item: MapItem) -> bool:
	for c in get_children():
		if c == item: return true
	return false

func transfer_item(item: MapItem, container: Node) -> void:
	if not has_specific_item(item): return
	item.reparent(container)

func transfer_all_items(container: Node) -> void:
	for item in get_children():
		if item is MapItem: item.reparent(container)
