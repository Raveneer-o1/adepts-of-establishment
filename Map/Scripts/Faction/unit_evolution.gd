class_name UnitEvolution
extends FactionUpgrade

@export var evolving_from: StringName
@export var evolving_into: StringName

func _ready() -> void:
	assert(evolving_into in GlobalDefs.units_database.database)
	assert(evolving_from in GlobalDefs.units_database.database)
