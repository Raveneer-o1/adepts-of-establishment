class_name HeroData
extends UnitData

var leading_party: MapParty

# WARNING: remove this, testing only
func initialize(personal: String = "") -> bool:
	var res := super.initialize(personal)
	if not OS.is_debug_build(): return res
	
	needed_xp = 1
	return res
