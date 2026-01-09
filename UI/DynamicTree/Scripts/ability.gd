class_name DynamicTree_Ability
extends MarginContainer

@onready var button: Button = $Ability

var this_ability: HeroAbility

var tree: UI_DynamicTree

func _ready() -> void:
	var parent := get_parent()
	while parent:
		if parent is UI_DynamicTree:
			tree = parent
			return
		parent = parent.get_parent()
	push_error("UI_DynamicTree is not found")
	queue_free()

func init_ability(ability: HeroAbility) -> void:
	if not ability:
		push_error("Null ability")
		queue_free()
		return
	button.text = ability.ability_name
	this_ability = ability


func _on_ability_pressed() -> void:
	tree.ability_selected.emit(this_ability)
