extends MapUnitEffect

const TEST = preload("uid://djeo7bmtq4rr5")

func apply(...args: Array) -> void:
	if not unit: await ready
	if not unit.party: return
	var instance: PartyEffectFromUnit = TEST.instantiate()
	instance.source_unit = unit
	unit.party.add_child(instance)
