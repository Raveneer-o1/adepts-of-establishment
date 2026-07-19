extends Unit

func die() -> void:
	if not initialized:
		return
	if _death_visualized: return
	
	parameters.hp = parameters.max_hp
	parameters.dead = false
	
	update_visuals()
