class_name MapResourceContainer
extends Node

@export var gold: int = 0:
	get: return gold
	set(value):
		if value == gold: return
		gold = value
		resource_count_updated.emit()
@export var stone: int = 0:
	get: return stone
	set(value):
		if value == stone: return
		stone = value
		resource_count_updated.emit()
@export var mana: int = 0:
	get: return mana
	set(value):
		if value == mana: return
		mana = value
		resource_count_updated.emit()

signal resource_count_updated
