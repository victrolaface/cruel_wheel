"""
extends Resource
class_name ComponentMetaStateData

export(bool) var enabled
export(bool) var destroyed
export(bool) var parented
export(bool) var initialized


func _init():
	resource_local_to_scene = true
	enabled = false
	destroyed = false
	parented = false
	initialized = false
"""
