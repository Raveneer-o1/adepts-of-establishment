class_name UnitInfoPopup
extends PopupBase

@onready var unit_info_panel: UnitInfoPanel = $UnitInfoPanel

func show_unit(unit: UnitData) -> void:
	unit_info_panel.fill_data(unit)
	# TODO: replace portraits
	#unit_info_panel.replace_portrait(unit)
	show()
