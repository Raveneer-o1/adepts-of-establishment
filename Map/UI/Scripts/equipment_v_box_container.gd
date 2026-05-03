class_name EquipmentVBoxContainer
extends VBoxContainer

var party_ui_manager: PartyUIManager

func _ready() -> void:
	_set_refs()

func _set_refs() -> void:
	var parent := get_parent()
	while parent:
		if parent is PartyUIManager:
			party_ui_manager = parent
			break
		parent = parent.get_parent()
	assert(party_ui_manager)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var item: EquippableMapItem = data.item if \
		data is PartyEditorItem and data.item is EquippableMapItem \
		else null
	if not item: return false
	var party := party_ui_manager.currently_filled_party
	if not party: return false
	return item.can_be_equipped(party)

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var item: EquippableMapItem = data.item if \
		data is PartyEditorItem and data.item is EquippableMapItem \
		else null
	if not item: return
	var party := party_ui_manager.currently_filled_party
	if not party: return
	if not item.try_equipping(party): return
	data.reparent(self)
