extends Node
class_name SoundPlayer

## idk... plays sounds

var damage_sounds: Array[AudioStreamPlayer]
var miss_sounds: Array[AudioStreamPlayer]
var evade_sounds: Array[AudioStreamPlayer]
var immunity_sounds: Array[AudioStreamPlayer]
var shield_sounds: Array[AudioStreamPlayer]
var attack_sounds: Array[AudioStreamPlayer]
var heal_sounds: Array[AudioStreamPlayer]
var death_sounds: Array[AudioStreamPlayer]

# Utility array for batch population of arrays in a single loop.
# Each element is an array with two elements: target array and source node
@onready var _containers: Array[Array] = [
	[miss_sounds, $Miss],
	[damage_sounds, $Damage],
	[evade_sounds, $Evade],
	[immunity_sounds, $Immunity],
	[shield_sounds, $Shield],
	[attack_sounds, $Attack],
	[heal_sounds, $Heal],
	[death_sounds, $Death],
]

const SOUND_FACTOR = 2.0

func play_damage_sound(factor: float = 1.0) -> void:
	if not damage_sounds: return
	var player: AudioStreamPlayer = damage_sounds.pick_random()
	player.volume_db = factor * SOUND_FACTOR
	player.play()

var playing_miss_sound: bool = false

func play_miss_sound() -> void:
	if playing_miss_sound: return
	if not miss_sounds: return
	playing_miss_sound = true
	EventBus.attack_animation_finished.connect(func(a: Unit)-> void: playing_miss_sound = false)
	miss_sounds.pick_random().play()

func play_evade_sound() -> void:
	if not evade_sounds: return
	evade_sounds.pick_random().play()

func play_shield_sound() -> void:
	if not shield_sounds: return
	shield_sounds.pick_random().play()

func play_immunity_sound() -> void:
	if not immunity_sounds: return
	immunity_sounds.pick_random().play()

func play_attack_sound() -> void:
	if not attack_sounds: return
	attack_sounds.pick_random().play()

func play_heal_sound(factor: float = 1.0) -> void:
	if not heal_sounds: return
	var player: AudioStreamPlayer = heal_sounds.pick_random()
	player.volume_db = factor * SOUND_FACTOR
	player.play()

func play_death_sound() -> void:
	if not death_sounds: return
	death_sounds.pick_random().play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for a: Array in _containers:
		a[0].assign(
			a[1].get_children().filter(
				func(n: Variant) -> bool: return n is AudioStreamPlayer
			)
		)
