class_name __DefaultArcher__

const HP_INCREASE_FACTOR = 1.02
const DMG_INCREASE_FACTOR = 1.1
const EVASION_INCREASE_FACTOR = 1.01

const ACCURACY_INCREASE = 1.1

static func levelup(unit: UnitData) -> void:
	@warning_ignore("narrowing_conversion")
	unit.max_hp *= HP_INCREASE_FACTOR
	@warning_ignore("narrowing_conversion")
	unit.base_damage *= DMG_INCREASE_FACTOR
	unit.evasion *= EVASION_INCREASE_FACTOR
	for attack_data in unit.attack_data:
		var chance_to_miss := 1.0 - attack_data.accuracy
		if is_zero_approx(chance_to_miss): continue
		attack_data.accuracy = 1.0 - chance_to_miss / ACCURACY_INCREASE
