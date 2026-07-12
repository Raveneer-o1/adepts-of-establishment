class_name UI_UnitPanel_BaseDamageContainer
extends VBoxContainer

@onready var base_damage_label: Label = $BaseDamageLabel

func set_value(val: int) -> void:
	base_damage_label.text = str(val)
