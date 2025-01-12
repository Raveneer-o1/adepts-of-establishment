extends Node

@onready var api: PlayerAPI = get_parent()

func choose_action(unit: Unit) -> void:
	var avaliable_targets := api.combat_system.find_avaliable_targets()
	if avaliable_targets.is_empty() or \
			unit.parameters.hp < unit.parameters.max_hp * 0.2:
		api.use_defense_stance()
		return
	
	var targets_need = api.combat_system.combat_logic.current_attack.targets_needed
	while targets_need > 0:
		if avaliable_targets.is_empty():
			api.start_attack()
		api.choose_unit(avaliable_targets.pick_random())
		avaliable_targets = api.combat_system.find_avaliable_targets()
		targets_need -= 1

func _ready() -> void:
	api.turn_started.connect(choose_action)
