class_name UI_UnitPanel_HP_Container
extends VBoxContainer

@onready var hp_progress_bar: TextureProgressBar = $HPProgressBar
@onready var label: Label = $HPProgressBar/Label

const HP_LABEL = "%d/%d"

func set_value(current_val: int, max_val: int) -> void:
	hp_progress_bar.max_value = max_val
	hp_progress_bar.value = current_val
	label.text = HP_LABEL % [current_val, max_val]
