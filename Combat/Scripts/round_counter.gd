extends RichTextLabel

const TEXT = "Round: [font_size=25]%d[/font_size]"

var current_round: int = 1

func update_current_round() -> void:
	current_round += 1
	text = TEXT % current_round

func _ready() -> void:
	EventBus.round_started.connect(update_current_round)
