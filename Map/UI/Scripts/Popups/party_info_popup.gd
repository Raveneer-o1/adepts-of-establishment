class_name PartyInfoPopup
extends PopupBase

@onready var _0: Label = \
	$"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Frontline/0/Label"
@onready var _1: Label = \
	$"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Backline/1/Label"
@onready var _2: Label = \
	$"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Frontline/2/Label"
@onready var _3: Label = \
	$"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Backline/3/Label"
@onready var _4: Label = \
	$"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Frontline/4/Label"
@onready var _5: Label = \
	$"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Backline/5/Label"
@onready var _6: Label = \
	$"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Frontline/6/Label"
@onready var party_name: Label = $Control/PanelContainer/MarginContainer/VBoxContainer/PartyName

@onready var labels: Array[Label] = [_0,_1,_2,_3,_4,_5,_6]

func show_party(party: MapParty) -> void:
	for label in labels: label.text = ""
	party_name.text = party.party_name
	for unit in party.parameters.get_unit_data():
		var pos := unit.party_position
		if pos < 0: continue
		if pos > labels.size(): continue
		if labels[pos].text: continue
		labels[pos].text = unit.unit_name
	show()
