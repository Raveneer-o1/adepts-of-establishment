extends MapUnitEffect

const BUFF_TO_SPECIFIC_TYPE = preload("uid://coeno73un1pmh")

func apply(...args: Array) -> void:
	if not unit.party: return
	var instance: PartyEffectFromUnit = BUFF_TO_SPECIFIC_TYPE.instantiate()
	instance.source_unit = unit
	instance.apply_effect.callv(args)
	unit.party.add_child(instance)
