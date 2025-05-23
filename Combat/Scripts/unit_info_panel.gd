extends Control
class_name UnitInfoPanel

@onready var info := get_node("Panel/MainContainer/LeftContainer/DesctiprionPanel/DescriptionLabel") as RichTextLabel
@onready var full_info: RichTextLabel = $Panel/MainContainer/RightContainer/FullInfo
@onready var portrait: TextureRect = $Panel/MainContainer/LeftContainer/PortraitPanel/PortraitMargin/Portrait

# Formatting constants for unit stats to maintain consistency in text presentation.
const HP_LINE = "HP: %d/%d\n"
const DAMAGE_LINE = "Damage: %d (%s)\n"
const ARMOR_LINE = "Armor: %d\n"
const EVASION_LINE = "Evasion: %.2f\n"
const ACCURACY_LINE = "Accuracy: %s\n"
const INITIATIVE_LINE = "Initiative: %s\n"
const TYPE_LINE = "Type: %s\n"
const EFFECT_LINE = "Effects: %s\n"
const APPLIED_EFFECT_LINE = "\n[b]%s[/b]: %s\n"
const DESCRIOTION_LINE = "\n\n---\n%s"
const BRACKETS_ENCLOSURE = "(%s)"

# Converts an attack type enum value into a human-readable string.
func attack_type_to_str(type: EventBus.AttackType) -> String:
	return EventBus.AttackType.keys()[type]

func fill_text_data(unit: Unit) -> void:
	info.text = ""  # Clear short info text
	full_info.text = ""  # Clear detailed info text
	
	# Format unit attributes for display
	var hp_text: String = HP_LINE % [unit.parameters.hp, unit.parameters.max_hp]
	var armor_text := ARMOR_LINE % unit.parameters.armor
	var evasion_text := EVASION_LINE % unit.parameters.evasion
	var damage_text: String = ""
	var type_text: String = ""
	var initiative_text: String = ""
	var accuracy_text: String = ""
	var effect_text: String = ""
	var applied_effect_text: String = ""
	
	# Process each attack to generate detailed info
	for a in unit.parameters.attacks:
		# Calculate attack damage, accounting for overrides and multipliers
		@warning_ignore("narrowing_conversion") 
		var dmg: int = a.damage_multiplier if a.damage_override else \
				a.damage_multiplier * unit.parameters.base_damage
		
		# Format damage and target count
		if a.targets_needed == 1:
			damage_text += str(dmg) + ", "
		else:
			damage_text += str(dmg) + " x%d, " % a.targets_needed
		
		# Append initiative, accuracy, and type info
		initiative_text += str(a.initiative) + ", "
		accuracy_text += str(a.accuracy) + ", "
		type_text += attack_type_to_str(a.type) + ", "
		
		# Collect effects applied by the attack
		var local_effect_list: String = ""
		for effect: String in a.applying_effects:
			local_effect_list += effect + ", "
		effect_text += BRACKETS_ENCLOSURE % local_effect_list.trim_suffix(", ") \
				if local_effect_list != "" else "-"
	
	for effect in unit.parameters.get_children():
		if not effect is AppliedEffect:
			continue
		applied_effect_text += APPLIED_EFFECT_LINE % [
			(effect as AppliedEffect).effect_name,
			(effect as AppliedEffect)._get_description()
		]
	
	# Trim trailing commas from text fields
	initiative_text = initiative_text.trim_suffix(", ")
	damage_text = damage_text.trim_suffix(", ")
	type_text = type_text.trim_suffix(", ")
	accuracy_text = accuracy_text.trim_suffix(", ")
	#effect_text = effect_text.trim_suffix(", ")
	
	# Finalize formatted text for detailed info
	damage_text = DAMAGE_LINE % [unit.parameters.base_damage, damage_text]
	accuracy_text = ACCURACY_LINE % accuracy_text
	initiative_text = INITIATIVE_LINE % initiative_text
	type_text = TYPE_LINE % type_text
	effect_text = EFFECT_LINE % effect_text
	
	full_info.append_text(\
			hp_text + \
			armor_text + \
			evasion_text + \
			damage_text + \
			effect_text + \
			accuracy_text + \
			initiative_text + \
			type_text + \
			applied_effect_text + \
			DESCRIOTION_LINE % unit.full_description
	)
	info.text = hp_text + unit.brief_description


func replace_portrait(texture: Texture2D) -> void:
	if texture != null:
		portrait.texture = texture


## Populates the UI panel with formatted unit information.
## Displays HP, armor, base damage, and details of each attack
## (damage, initiative, accuracy, type, effects).
func populate_panel_with_info(unit: Unit) -> void:
	fill_text_data(unit)
	
	replace_portrait(unit.portrait_texture)
	
	# Set panel visibility
	visible = true



func _ready() -> void:
	get_node("/root/EventBus").unit_description_requested.connect(populate_panel_with_info)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not (event as InputEventMouse).is_pressed():
			visible = false
