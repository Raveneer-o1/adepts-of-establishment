class_name Party extends Node2D

const MAX_UNITS_NUMBER = 7

var other_party: Party

var units: Array[Unit] = []


func initialize_variables() -> void:
	for i in range(MAX_UNITS_NUMBER):
		units.append(null)
	

func _ready() -> void:
	initialize_variables()
