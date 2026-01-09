class_name UnitEvolution
extends FactionUpgrade

@export var evolving_from: StringName
@export var evolving_into: StringName

@export var gold_cost := 0
@export var stone_cost := 0
@export var mana_cost := 0

var cost: ResourceCost:
	get: return ResourceCost.new(gold_cost, stone_cost, mana_cost)

func _ready() -> void:
	assert(evolving_into in GlobalDefs.database_path.database)
	assert(evolving_from in GlobalDefs.database_path.database)
