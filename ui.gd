extends Control

func _ready() -> void:
	%VesrionLabel.text = ProjectSettings.get_setting("application/config/version")
