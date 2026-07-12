extends Control
class_name UnitInfoPanel

#@onready var info := get_node("Panel/MainContainer/LeftContainer/DesctiprionPanel/DescriptionLabel") as RichTextLabel
#@onready var full_info: RichTextLabel = $Panel/MainContainer/RightContainer/FullInfo
@onready var portrait: TextureRect = $Panel/MainContainer/LeftContainer/PortraitPanel/PortraitMargin/Portrait

@onready var hp_container: UI_UnitPanel_HP_Container = $Panel/MainContainer/MarginContainer/RightContainer/BaseInfo/HPContainer
@onready var armor_container: UI_UnitPanel_ArmorContainer = $Panel/MainContainer/MarginContainer/RightContainer/BaseInfo/ArmorContainer
@onready var evasion_container: UI_UnitPanel_EvasionContainer = $Panel/MainContainer/MarginContainer/RightContainer/BaseInfo/EvasionContainer
@onready var base_damage_container: UI_UnitPanel_BaseDamageContainer = $Panel/MainContainer/MarginContainer/RightContainer/BaseInfo/BaseDamageContainer
@onready var level_label: Label = $Panel/MainContainer/MarginContainer/RightContainer/LevelLabel
@onready var attacks_container: UI_UnitPanel_AttacksContainer = $Panel/MainContainer/MarginContainer/RightContainer/Attacks

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
	return s

func _set_hp(u: Variant) -> void:
	if u is Unit:
		hp_container.set_value(
			u.parameters.hp,
			u.parameters.max_hp
		)
	elif u is UnitData:
		hp_container.set_value(
			u.current_hp,
			u.max_hp
		)
	else: push_error("Unexpected type")

func _set_armor(u: Variant) -> void:
	if u is Unit:
		armor_container.set_value(
			u.parameters.armor
		)
	elif u is UnitData:
		armor_container.set_value(
			u.armor
		)
	else: push_error("Unexpected type")

func _set_evasion(u: Variant) -> void:
	if u is Unit:
		evasion_container.set_value(
			u.parameters.evasion
		)
	elif u is UnitData:
		evasion_container.set_value(
			u.evasion
		)
	else: push_error("Unexpected type")

func _set_base_dmg(u: Variant) -> void:
	if u is Unit:
		base_damage_container.set_value(
			u.parameters.base_damage
		)
	elif u is UnitData:
		base_damage_container.set_value(
			u.base_damage
		)
	else: push_error("Unexpected type")

func _set_attacks(u: Variant) -> void:
	const LEVEL_TEXT = "%s, \tLevel %d"
	if u is Unit:
		attacks_container.fill_attacks(u.parameters.attacks)
	elif u is UnitData:
		attacks_container.fill_attacks(u.attack_data)
	else: push_error("Unexpected type")

func _set_name(u: Variant) -> void:
	const LEVEL_TEXT = "%s, \tLevel %d"
	if u is Unit:
		level_label.text = LEVEL_TEXT % [u.unit_name, u.parameters.level]
	elif u is UnitData:
		level_label.text = LEVEL_TEXT % [
			u.personal_name if u.personal_name else u.unit_name,
			u.level
		]
	else: push_error("Unexpected type")


func fill_data(unit: Variant) -> void:
	assert(unit is Unit or unit is UnitData)
	_set_name(unit)
	_set_attacks(unit)
	_set_base_dmg(unit)
	_set_evasion(unit)
	_set_armor(unit)
	_set_hp(unit)

func fill_text_data(unit: Unit) -> void:
	fill_data(unit)

func replace_portrait(texture_path: String) -> void:
	var texture := DataBuffer.get_image(texture_path)
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
