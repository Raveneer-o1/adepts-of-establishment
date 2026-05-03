@abstract
class_name EquippableMapItem
extends MapItem

## Equipment slot this item occupies. The item cannot be equipped if 
## the corresponding slot is already occupied or otherwise unavailable.
var slot: EquipmentSlot

## The party currently equipping this item.
var by_party: MapParty:
	get: return (get_parent() as PartyInventory).get_parent()

func equip(party: MapParty) -> void:
	if is_equipped(): return
	var prev_item: EquippableMapItem = party.equipped_items.get(slot)
	if prev_item: prev_item.unequip()
	if slot == EquipmentSlot.Undefined:
		party.equipped_items_list.append(self)
	else:
		party.equipped_items[slot] = self
	_equip(party)

func unequip() -> void:
	if not by_party: return
	if slot == EquipmentSlot.Undefined:
		by_party.equipped_items_list.erase(self)
	elif by_party.equipped_items.get(slot) == self:
		by_party.equipped_items[slot] = null
	_unequip()

@abstract func _unequip() -> void
@abstract func _equip(party: MapParty) -> void
@abstract func can_be_equipped(party: MapParty) -> bool

func is_equipped() -> bool:
	if not by_party: return false
	if by_party.equipped_items_list.has(self): return true
	return by_party.equipped_items.get(slot) == self

func try_equipping(party: MapParty) -> bool:
	if not can_be_equipped(party): return false
	#if slot != EquipmentSlot.Undefined and \
		#party.equipped_items.get(slot): return false
	equip(party)
	return true

func can_be_applied_to(where: Variant) -> bool:
	if where is not MapParty: return false
	return can_be_equipped(where)

func apply_to(where: Variant) -> void:
	if where is not MapParty: return
	equip(where)
	EventBus.item_equipped.emit(self, where)

enum EquipmentSlot{
	Undefined,
	RightArm,
	LeftArm,
	Chest,
	Head,
	Legs,
	Banner,
}
