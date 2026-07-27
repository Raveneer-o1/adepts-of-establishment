extends RichTextLabel

const TEXT = "Round: [font_size=25]%d[/font_size]"

#var current_round: int = 1

func update_current_round() -> void:
	var current_round: int = CombatSystem.get_combat_system().combat_logic.current_round
	text = TEXT % current_round

func _ready() -> void:
	EventBus.round_started.connect(update_current_round)
