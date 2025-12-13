class_name PartyInventory
extends Node

var items: Array[MapItem]:
	get:
		var res: Array[MapItem] = []
		for c in get_children():
			if c is MapItem: res.append(c)
		return res
