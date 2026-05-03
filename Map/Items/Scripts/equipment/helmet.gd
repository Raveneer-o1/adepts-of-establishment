extends EquippableMapItem

@export var armor_increase := 200

const HERO_BUFF = preload("uid://scnuaabsaxmo")


func _equip(party: MapParty) -> void:
	var effect : PartyEffectFromItem = HERO_BUFF.instantiate()
	party.add_child(effect)
	effect.apply_effect(self, armor_increase)
	effect.stat = PartyEffectFromUnit.StatBuff.armor

func can_be_equipped(party: MapParty) -> bool:
	return true

func _unequip() -> void:
	pass
