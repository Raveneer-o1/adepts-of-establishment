extends Control
class_name UnitInfoPanel

@onready var info = get_node("Panel/MainContainer/LeftContainer/DesctiprionPanel/DescriptionLabel") as RichTextLabel
@onready var full_info: RichTextLabel = $Panel/MainContainer/RightContainer/FullInfo

const HP_LINE = "HP: %d"
const MAX_HP_LINE = " / %d \n"
const DAMAGE_LINE = "Damage: %d ("

func _ready() -> void:
	get_node("/root/EventBus").unit_description_requested.connect(populate_panel_with_info)

func populate_panel_with_info(unit: Unit) -> void:
	info.text = ""
	full_info.text = ""
	
	info.text += HP_LINE % unit.parameters.hp + MAX_HP_LINE % unit.parameters.max_hp
	
	# TODO: replace add_text with appent_text
	full_info.text += (DAMAGE_LINE % unit.parameters.base_damage)
	for a in unit.parameters.attacks:
		@warning_ignore("narrowing_conversion") var dmg: int = a.damage_multiplier if a.damage_override \
				else a.damage_multiplier * unit.parameters.base_damage
		full_info.text += (" " + str(dmg))
	full_info.text += (")\n")
	
	full_info.text += "Armor: %d\n" % unit.parameters.armor
	
	#print(full_info.text)
	visible = true


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not (event as InputEventMouse).is_pressed():
			visible = false
