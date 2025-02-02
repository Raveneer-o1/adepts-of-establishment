extends BasePolicy

func apply_policy(attack: Attack, index: int, finalize: bool) -> void:
	if attack.target_spots[index].unit != null:
		return
	var corpse_container: Node = attack.target_spots[index].corpse_container
	if corpse_container.get_child_count() == 0:
		return
	
	(corpse_container.get_child(0) as Unit).resurrect()
