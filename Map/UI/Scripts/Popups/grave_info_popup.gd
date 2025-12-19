class_name GraveInfoPopup
extends PopupBase

@onready var labels_container: VBoxContainer = $Root/PanelContainer/MarginContainer/VBoxContainer

const PARTY_LINE = "%s (%d units)"

func show_grave(grave: MapPartyGrave) -> void:
	show()
	for label in labels_container.get_children():
		label.queue_free()
	for party in grave.get_buried_parties():
		var label := Label.new()
		label.text = PARTY_LINE % [party.party_name, party.units.size()]
		labels_container.add_child(label)

func _on_root_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		for label in labels_container.get_children():
			label.queue_free()
		hide_popup()
