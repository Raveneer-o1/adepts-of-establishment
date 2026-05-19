class_name UnitEvolution
extends FactionUpgrade

@export var evolving_from: StringName
@export var evolving_into: StringName

# NOTE: change to true when done.
# Set to true to validate unit evolution assets during game startup.
# When enabled, checks that units are implemented, buildings are configured.
# Helps detect typos and other errors that are difficult to debug manually.
# Set to false to skip validation while assets are work-in-progress.
# Does not affect release builds — validation only runs in debug.
const _DEBUG = false

func _check_self() -> void:
	if evolving_into not in GlobalDefs.units_database.database:
		valid = false
	if evolving_from not in GlobalDefs.units_database.database:
		valid = false

func _ready() -> void:
	if not _DEBUG or not OS.is_debug_build(): _check_self(); return
	assert(
		evolving_into in GlobalDefs.units_database.database,
		"%s is not a registered unit" % evolving_into
	)
	assert(
		evolving_from in GlobalDefs.units_database.database,
		"%s is not a registered unit" % evolving_from
	)
