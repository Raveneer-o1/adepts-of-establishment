extends Control
class_name UnitInfoPanel

@onready var info := get_node("Panel/MainContainer/LeftContainer/DesctiprionPanel/DescriptionLabel") as RichTextLabel
@onready var full_info: RichTextLabel = $Panel/MainContainer/RightContainer/FullInfo
@onready var portrait: TextureRect = $Panel/MainContainer/LeftContainer/PortraitPanel/PortraitMargin/Portrait

# Formatting constants for unit stats to maintain consistency in text presentation.
const HP_LINE = "HP: %d/%d\n"
const XP_LINE = "XP: %d/%d\n"
const DAMAGE_LINE = "Damage: %d (%s)\n"
const ARMOR_LINE = "Armor: %d\n"
const EVASION_LINE = "Evasion: %s\n"
const ACCURACY_LINE = "Accuracy: %s\n"
const INITIATIVE_LINE = "Initiative: %s\n"
const TYPE_LINE = "Type: %s\n"
const EFFECT_LINE = "Effects: %s\n"
const APPLIED_EFFECT_LINE = "\n[b]%s[/b]: %s\n"
const SHORT_APPLIED_EFFECT_LINE = "%s, "
const DESCRIOTION_LINE = "\n\n---\n%s"
const BRACKETS_ENCLOSURE = "(%s)"

# Converts an attack type enum value into a human-readable string.
static func attack_type_to_str(type: GlobalDefs.AttackType) -> String:
	return GlobalDefs.AttackType.keys()[type]

static func get_accuracy_text(val: float) -> String:
	val = UnitAttack.get_accuracy_representation(val)
	if is_nan(val): return "0"
	if is_inf(val): return "guaranteed"
	return str(roundi(val))

static func get_evasion_text(val: float) -> String:
	val = UnitParameters.get_evasion_representation(val)
	var s: String = ""
	if is_nan(val): s = "0"
	elif is_inf(val): s = "Guaranteed"
	else: s = str(int(val * 100.0))
	return EVASION_LINE % s

func fill_data(unit: UnitData) -> void:
	info.text = ""
	full_info.text = ""
	
	var hp_text: String = HP_LINE % [unit.current_hp, unit.max_hp]
	var xp_text: String = XP_LINE % [unit.current_xp, unit.needed_xp]
	var armor_text := ARMOR_LINE % unit.armor
	var evasion_text := get_evasion_text(unit.evasion)
	var damage_text: String = ""
	var type_text: String = ""
	var initiative_text: String = ""
	var accuracy_text: String = ""
	var effect_text: String = ""
	var applied_effect_text: String = ""
	
	for a in unit.attack_data:
		@warning_ignore("narrowing_conversion") 
		var dmg: int = a.damage_multiplier if a.damage_override else \
				a.damage_multiplier * unit.base_damage
		
		if a.targets_needed == 1:
			damage_text += str(dmg) + ", "
		else:
			damage_text += str(dmg) + " x%d, " % a.targets_needed
		
		initiative_text += str(a.initiative) + ", "
		accuracy_text += get_accuracy_text(a.accuracy) + ", "
		type_text += attack_type_to_str(a.type) + ", "
		
		var local_effect_list: String = ""
		for effect: String in a.applying_effects:
			local_effect_list += effect.to_snake_case().replace("_", " ") + ", "
		effect_text += BRACKETS_ENCLOSURE % local_effect_list.trim_suffix(", ") \
				if local_effect_list != "" else "-"
	
	for effect in unit.effects:
		applied_effect_text += SHORT_APPLIED_EFFECT_LINE % effect[&"effect_name"]
	
	applied_effect_text = applied_effect_text.trim_suffix(", ")
	initiative_text = initiative_text.trim_suffix(", ")
	damage_text = damage_text.trim_suffix(", ")
	type_text = type_text.trim_suffix(", ")
	accuracy_text = accuracy_text.trim_suffix(", ")
	
	damage_text = DAMAGE_LINE % [unit.base_damage, damage_text]
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
			applied_effect_text
	)
	
	full_info.append_text(DESCRIOTION_LINE % unit.description)
	
	info.text = "%s%s\n%s" % [
		hp_text,
		xp_text,
		unit.brief_description
	] 

func fill_text_data(unit: Unit) -> void:
	info.text = ""
	full_info.text = ""
	
	var hp_text: String = HP_LINE % [unit.parameters.hp, unit.parameters.max_hp]
	var xp_text: String = XP_LINE % [unit.current_xp, unit.needed_xp]
	var armor_text := ARMOR_LINE % unit.parameters.armor
	var evasion_text := get_evasion_text(unit.parameters.evasion)
	var damage_text: String = ""
	var type_text: String = ""
	var initiative_text: String = ""
	var accuracy_text: String = ""
	var effect_text: String = ""
	var applied_effect_text: String = ""
	
	for a in unit.parameters.attacks:
		@warning_ignore("narrowing_conversion") 
		var dmg: int = a.damage_multiplier if a.damage_override else \
				a.damage_multiplier * unit.parameters.base_damage
		
		if a.targets_needed == 1:
			damage_text += str(dmg) + ", "
		else:
			damage_text += str(dmg) + " x%d, " % a.targets_needed
		
		initiative_text += str(a.initiative) + ", "
		accuracy_text += get_accuracy_text(a.accuracy) + ", "
		type_text += attack_type_to_str(a.type) + ", "
		
		var local_effect_list: String = ""
		for effect: String in a.applying_effects:
			local_effect_list += effect.to_snake_case().replace("_", " ") + ", "
		effect_text += BRACKETS_ENCLOSURE % local_effect_list.trim_suffix(", ") \
				if local_effect_list != "" else "-"
	
	for effect in unit.parameters.get_children():
		if effect is not AppliedEffect:
			continue
		applied_effect_text += APPLIED_EFFECT_LINE % [
			(effect as AppliedEffect).effect_name,
			(effect as AppliedEffect)._get_description()
		]
	
	initiative_text = initiative_text.trim_suffix(", ")
	damage_text = damage_text.trim_suffix(", ")
	type_text = type_text.trim_suffix(", ")
	accuracy_text = accuracy_text.trim_suffix(", ")
	
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
			applied_effect_text
	)
	
	var ability_text: String = ""
	for a in unit.parameters.attacks:
		if a.description != "":
			ability_text += "\n%s\n" % a.description
	if ability_text != "":
		full_info.append_text(DESCRIOTION_LINE % ability_text)
	
	full_info.append_text(DESCRIOTION_LINE % unit.full_description)
	
	info.text = "%s\n%s\n%s" %[
		hp_text,
		xp_text,
		unit.brief_description
	] 

func replace_portrait(texture_path: String) -> void:
	var texture := ImageBuffer.get_image(texture_path)
	if texture != null:
		portrait.texture = texture
		portrait.show()
	else: portrait.hide()

## Populates the UI panel with formatted unit information.
## Displays HP, armor, base damage, and details of each attack
## (damage, initiative, accuracy, type, effects).
func populate_panel_with_info(unit: Unit) -> void:
	fill_text_data(unit)
	
	replace_portrait(unit.portrait_texture_path)
	
	visible = true

func _ready() -> void:
	get_node("/root/EventBus").unit_description_requested.connect(populate_panel_with_info)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not (event as InputEventMouse).is_pressed():
			visible = false
