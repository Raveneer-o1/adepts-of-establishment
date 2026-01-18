extends MapUnitEffect

const THE_WELKIN_WARRIOR = preload("uid://ddcf6gclbb6cw")

func apply(...args: Array) -> void:
	if not unit.party: return
	var instance: PartyEffectFromUnit = THE_WELKIN_WARRIOR.instantiate()
	instance.source_unit = unit
	unit.party.add_child(instance)
	instance.apply_effect.callv(args)
