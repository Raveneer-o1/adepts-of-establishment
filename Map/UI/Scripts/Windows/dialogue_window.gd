class_name DialogueUI
extends WindowBase


@onready var portrait_left: TextureRect = %UI_DialogueWindow_PortraitLeft
@onready var portrait_right: TextureRect = %UI_DialogueWindow_PortraitRight

@onready var main_text: RichTextLabel = %UI_DialogueWindow_MainTextLabel
@onready var choice_buttons: GridContainer = %UI_DialogueWindow_ChoiceButtons_Container

var _current_dialogue: DialogueNode
var _last_position_left := true

const CHOICE_BUTTON = preload("uid://bhc5nlf4nxnx6")

func start_dialogue(dialogue: DialogueNode) -> void:
	if not dialogue: return
	_last_position_left = true
	_step_dialogue(dialogue)
	show()

func _get_portrait_texture() -> Texture2D:
	if not _current_dialogue: return null
	# TODO: request dynamic portrait data
	if _current_dialogue.dynamic_portrait: return null
	
	return DataBuffer.get_image(_current_dialogue.portrait_path) as Texture2D

func _set_portrait() -> void:
	if _current_dialogue.portrait_position == \
		DialogueNode.PortraitPosition.Unchanged: return
	_clear_portraits()
	match _current_dialogue.portrait_position:
		DialogueNode.PortraitPosition.AutoOpposite: 
			(portrait_right if _last_position_left else portrait_left)\
				.texture = _get_portrait_texture()
			_last_position_left = !_last_position_left
		DialogueNode.PortraitPosition.AutoSame: 
			(portrait_left if _last_position_left else portrait_right)\
				.texture = _get_portrait_texture()
		DialogueNode.PortraitPosition.Left: 
			portrait_left.texture = _get_portrait_texture()
			_last_position_left = true
		DialogueNode.PortraitPosition.Right: 
			portrait_right.texture = _get_portrait_texture()
			_last_position_left = false
		

func _make_choice(option: StringName) -> void:
	_step_dialogue(_current_dialogue.options.get(option))
	# TODO: attach triggers associated with the choice.

func _step_dialogue(dialogue: DialogueNode) -> void:
	if not dialogue: _clear(); return
	_current_dialogue = dialogue
	main_text.text = dialogue.text
	_set_portrait()
	_set_choices()

const DEFAULT_END_DIALOGUE_TEXT = "End dialogue."

func _add_end_dialogue_option() -> void:
	var new_button: Button = CHOICE_BUTTON.instantiate()
	new_button.pressed.connect(hide_window)
	new_button.text = DEFAULT_END_DIALOGUE_TEXT
	choice_buttons.add_child(new_button)

func _set_choices() -> void:
	for c in choice_buttons.get_children():
		c.queue_free()
	if not _current_dialogue.options: _add_end_dialogue_option()
	for choice in _current_dialogue.options:
		var new_button: Button = CHOICE_BUTTON.instantiate()
		new_button.pressed.connect(_make_choice.bind(choice))
		new_button.text = choice
		choice_buttons.add_child(new_button)

func _clear() -> void:
	hide_window()
	_current_dialogue = null
	_clear_portraits()

func _clear_portraits() -> void:
	portrait_left.texture = null
	portrait_right.texture = null

func _on_ui_dialogue_window_skip_dialogue_button_pressed() -> void:
	if _current_dialogue and not _current_dialogue.skippable: return
	hide_window()
