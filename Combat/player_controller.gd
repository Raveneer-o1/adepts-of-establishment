extends Node

@onready var api: PlayerAPI = get_parent()

func _ready() -> void:
	EventBus.spot_clicked.connect(api.choose_unit)
	EventBus.defense_clicked.connect(api.use_defense_stance)
	EventBus.wait_clicked.connect(api.use_waiting)
	EventBus.start_attack_clicked.connect(api.start_attack)
