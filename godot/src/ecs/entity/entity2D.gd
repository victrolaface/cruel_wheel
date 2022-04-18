class_name Entity2D extends Node2D

const _CLASS_NAME = "Entity2D"

var data: EntityData


func _init():
	data = EntityData.new(self, 0, self, {}, true)


func is_class(_class: String):
	return (data.enabled && _class == data.get_class()) or _class == _CLASS_NAME


func get_class():
	return _CLASS_NAME
