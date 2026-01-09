class_name UnitEvolution
extends FactionUpgrade

@export var evolving_from: StringName
@export var evolving_into: StringName

func _ready() -> void:
	assert(evolving_into in GlobalDefs.database_path.database)
	assert(evolving_from in GlobalDefs.database_path.database)
