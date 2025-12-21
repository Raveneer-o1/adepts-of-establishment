class_name CityInfoPopup
extends PopupBase

@onready var party_container: HBoxContainer = $Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/PartyContainer

@onready var g_0: Label = $"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/GarrisonContainer/Frontline/0/Label"
@onready var g_1: Label = $"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/GarrisonContainer/Backline/1/Label"
@onready var g_2: Label = $"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/GarrisonContainer/Frontline/2/Label"
@onready var g_3: Label = $"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/GarrisonContainer/Backline/3/Label"
@onready var g_4: Label = $"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/GarrisonContainer/Frontline/4/Label"
@onready var g_5: Label = $"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/GarrisonContainer/Backline/5/Label"
@onready var g_6: Label = $"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/GarrisonContainer/Frontline/6/Label"

@onready var _0: Label = $"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/PartyContainer/Frontline/0/Label"
@onready var _1: Label = $"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/PartyContainer/Backline/1/Label"
@onready var _2: Label = $"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/PartyContainer/Frontline/2/Label"
@onready var _3: Label = $"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/PartyContainer/Backline/3/Label"
@onready var _4: Label = $"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/PartyContainer/Frontline/4/Label"
@onready var _5: Label = $"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/PartyContainer/Backline/5/Label"
@onready var _6: Label = $"Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/PartyContainer/Frontline/6/Label"

@onready var garrison_labels: Array[Label] = [g_0, g_1, g_2, g_3, g_4, g_5, g_6]
@onready var party_labels: Array[Label] = [_0, _1, _2, _3, _4, _5, _6]

func show_city(city: MapCity) -> void:
	show()
	if city.party_inside:
		for l in party_labels:
			l.text = ""
		party_container.show()
		for data in city.party_inside.parameters.get_unit_data():
			var pos := data.party_position
			if pos > party_labels.size(): continue
			if pos < 0: continue
			party_labels[pos].text = data.personal_name \
				if data.personal_name else str(data.unit_name)
	else: party_container.hide()
	
	for l in garrison_labels:
		l.text = ""
	for data in city.units:
		var pos := data.party_position
		if pos > garrison_labels.size(): continue
		if pos < 0: continue
		garrison_labels[pos].text = data.personal_name \
			if data.personal_name else str(data.unit_name)
