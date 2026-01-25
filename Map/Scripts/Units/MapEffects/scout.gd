extends MapUnitEffect

const SCOUT = preload("uid://l4fgi42bx58p")

func apply(...args: Array) -> void:
	if not unit: await ready
	if not unit.party: return
	var instance: PartyEffectFromUnit = SCOUT.instantiate()
	instance.source_unit = unit
	unit.party.add_child(instance)
