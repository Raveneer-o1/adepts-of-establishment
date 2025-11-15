extends Node

var ambient_audio_list: Array[AudioStreamPlayer] = []

func _ready() -> void:
	#if OS.is_debug_build(): return
	for child in get_children():
		if child is AudioStreamPlayer:
			ambient_audio_list.append(child)
			child.play()
		else:
			var child_audio_list: Array[AudioStreamPlayer] = []
			for ch in child.get_children():
				if ch is AudioStreamPlayer:
					child_audio_list.append(ch)
			if child_audio_list: child_audio_list.pick_random().play()
