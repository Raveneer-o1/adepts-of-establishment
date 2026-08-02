class_name UnitTests_ItemList
extends ItemList

@onready var combat_test: UnitTests_Root = $".."

func _ready() -> void:
	for unit_name:StringName in GlobalDefs.units_database.database.keys():
		add_item(unit_name)

func select_unit(unit_name: String) -> void:
	for i in range(item_count):
		if unit_name == get_item_text(i):
			select(i)

func _on_item_activated(index: int) -> void:
	combat_test.add_unit(get_item_text(index))
