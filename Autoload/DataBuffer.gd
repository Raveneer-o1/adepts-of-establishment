extends Node

var loaded_images: Dictionary[String, CompressedTexture2D]
var loaded_units: Dictionary[StringName, UnitData]

## Loads and returns a compressed texture from the specified [param path].
## The texture is cached by [DataBuffer] for immediate retrieval on subsequent calls.
func get_image(path: String) -> CompressedTexture2D:
	if loaded_images.has(path): return loaded_images[path]
	if not path: return null
	if not FileAccess.file_exists(path):
		return null
	var loaded_resource := load(path)
	if not loaded_resource:
		push_error("Unable to load image from: \n\t%s" % path)
		return null
	loaded_images[path] = loaded_resource
	return loaded_resource

## Returns a newly initialized [UnitData] object.
## The object is not attached to any parent - serves as a temporary placeholder
## for accessing database values.
func get_unit_data(unit_name: StringName) -> UnitData:
	if loaded_units.has(unit_name): return loaded_units[unit_name]
	var data := UnitData.new()
	data.unit_name = unit_name
	if not data.initialize():
		data.queue_free()
		return null
	
	loaded_units[unit_name] = data
	return data
