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

## @experimental: will be replaced with a texture
const AVAILABLE_MODULATE = Color.PALE_GREEN
## @experimental: will be replaced with a texture
const ONLY_ONCE_MODULATE = Color.INDIAN_RED
## @experimental: will be replaced with a texture
const DEFAULT_MODULATE = Color.WHITE

func update() -> void:
	if not this_ability:
		push_error("Null ability")
		queue_free()
		return
	button.text = this_ability.ability_name
	button.disabled = (not this_ability.active) or this_ability.learned
	if button.disabled:
		button.modulate = DEFAULT_MODULATE
		return
	if not this_ability.optional: return
	if tree.this_tree.this_hero.level >= this_ability.required_level \
		and this_ability in tree.this_tree.available_list:
		button.modulate = ONLY_ONCE_MODULATE if this_ability.available_once \
			else AVAILABLE_MODULATE

func init_ability(ability: HeroAbility) -> void:
	this_ability = ability
	update()


func _on_ability_pressed() -> void:
	tree.ability_selected.emit(this_ability)
