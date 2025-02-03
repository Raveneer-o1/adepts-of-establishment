extends HBoxContainer
class_name MiniatureQueueManager

const UNIT_MINIATURE = preload("res://Combat/Scenes/unit_in_queue.tscn")
const MAX_MINIATURES_ON_SCREEN = 15

var hidden_miniatures: Array
var miniatures: Dictionary

func fill_queue(attacks_queue: Array[UnitAttack]) -> void:
	for miniature in get_children():
		miniature.queue_free()
	
	miniatures = {}
	
	var i: int = 1
	for attack in attacks_queue:
		add_miniature(attack, i)
		i += 1


func shift_miniature(atk: UnitAttack, place: int = get_child_count()) -> void:
	if not (miniatures.has(atk) and \
			is_instance_valid(miniatures[atk])):
		return
	
	const DISTANCE_BETWEEN_FLAGS = 65.0
	var unit_it_queue: UnitInQueue = miniatures[atk]
	unit_it_queue.animate_shift(place * DISTANCE_BETWEEN_FLAGS)
	
	await end_shifting_miniatures_animation
	move_child(unit_it_queue.get_parent(), place)

signal end_shifting_miniatures_animation


func add_miniature(attack: UnitAttack, i: int = get_child_count()) -> void:
	var new_miniature := UNIT_MINIATURE.instantiate()
	new_miniature.get_child(0).unit = attack.unit
	new_miniature.get_child(0).queue = self
	add_child(new_miniature)
	miniatures[attack] = new_miniature.get_child(0)
	
	
	if i > MAX_MINIATURES_ON_SCREEN:
		#(new_miniature.get_child(0) as AnimationPlayer).pause_animation()
		hidden_miniatures.append(new_miniature)
	else:
		new_miniature.get_child(0).animate_enter()


func remove_miniature(atk: UnitAttack) -> void:
	if miniatures.has(atk) and \
			is_instance_valid(miniatures[atk]):
		miniatures[atk].animate_exit()

func clear_nearest_miniature() -> void:
	if get_child_count() > 0:
		(get_child(0).get_child(0) as UnitInQueue).animate_exit()


func add_new_miniature() -> void:	
	if not hidden_miniatures.is_empty():
		hidden_miniatures.pop_front().get_child(0).animate_enter()
