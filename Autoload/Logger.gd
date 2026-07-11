extends Node

const LOG_FILE = "log.txt"
const BLOCK_DELIM = "====================="
const MSG_DELIM = "---"

# NOTE: This variable is meant to be changed directly in the code when needed.
## Filters out most log messages. If the build is run with the [code]-v[/code] or
## [code]--verbose[/code] command‑line argument, this is set to [code]true[/code] automatically.
var verbose_mode := true

func _ready() -> void:
	if not verbose_mode and OS.is_stdout_verbose():
		verbose_mode = true
	if not FileAccess.file_exists(LOG_FILE):
		# NOTE: Godot does not rescan files created this way, so the log file will
		# appear missing until you force a rescan.
		FileAccess.open(LOG_FILE, FileAccess.WRITE).close()

## Writes a log message without starting a new block.
## Intended for messages printed during the same call frame as the block that
## created them, to reduce log file bloat. Otherwise, prefer [method write].
## This method only writes when [member verbose_mode] is enabled.
## For important logs, use [method force_message].
func add_message(message: String, object: Variant) -> void:
	if not verbose_mode: return
	force_message(message, object)

## Similar to [method add_message], but writes the log regardless of
## [member verbose_mode].
func force_message(message: String, object: Variant) -> void:
	var file := _get_file()
	if not file: return
	
	file.store_line(_form_message(message, object))
	file.store_line(MSG_DELIM)
	
	file.close()

func _form_message(message: String, object: Variant) -> String:
	if object is CombatSystem:
		object = {
			"left party": EventBus.left_units,
			"right party": EventBus.right_units
		}
	return "(%s): \n\t%s" % [str(object), message]

## Starts a new block and writes the log message.
## The block header includes the current call stack for debugging. [br]
## [b]Note:[/b] Blocks are only printed in debug builds. In release builds,
## this is equivalent to [method add_message].
## This method only writes when [member verbose_mode] is enabled.
## For important logs, use [method force_write].
func write(message: String, object: Variant) -> void:
	if not verbose_mode: return
	force_write(message, object)

## Similar to [method write], but writes the log regardless of
## [member verbose_mode].
func force_write(message: String, object: Variant) -> void:
	if not OS.is_debug_build():
		add_message(message, object)
		return
	
	var file := _get_file()
	if not file: return
	
	# Block header
	file.store_line(BLOCK_DELIM)
	for d: Dictionary in get_stack():
		# Might want to skip the first line, as it is always this logger function.
		file.store_line("\t%s" % str(d))
	file.store_line("")
	
	file.store_line(_form_message(message, object))
	file.store_line(MSG_DELIM)
	
	file.close()

func _get_file() -> FileAccess:
	var file := FileAccess.open(LOG_FILE, FileAccess.READ_WRITE)
	file.seek_end()
	if not file:
		push_warning("Unable to write a log message. Error: %s" % \
			str( FileAccess.get_open_error() )
		)
	return file
