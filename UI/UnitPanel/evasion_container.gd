class_name UI_UnitPanel_EvasionContainer
extends VBoxContainer

@onready var evasion_label: Label = $EvasionLabel

func set_value(val: int) -> void:
	evasion_label.text = UnitInfoPanel.get_evasion_text(val)
