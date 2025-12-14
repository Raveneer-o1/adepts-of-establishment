extends Node

var loaded_images: Dictionary[String, ImageTexture]

func get_image(path: String) -> ImageTexture:
	if loaded_images.has(path): return loaded_images[path]
	var loaded_resource := load(path) as ImageTexture
	if not loaded_resource:
		push_error("Unable to load image from: \n\t%s" % path)
		return null
	loaded_images[path] = loaded_resource
	return loaded_resource
