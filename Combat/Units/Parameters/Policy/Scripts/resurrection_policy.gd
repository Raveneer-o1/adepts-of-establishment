extends BasePolicy

func apply_policy(attack: Attack, finalize: bool) -> void:
	for t in attack.target_references:
		if not t.spot: continue
		var corpse_container: Node = t.spot.corpse_container
		if corpse_container.get_child_count() == 0:
			continue
		(corpse_container.get_children().pick_random() as Unit).resurrect()
	attack.standard_resolution()
