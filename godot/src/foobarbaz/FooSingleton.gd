tool
class_name FooSingleton extends Singleton

const _CLASS_NAME = "FooSingleton"
const _PATH = "res://src/foobarbaz/FooSingleton.gd"


func _init(_manager = null):
	self.resource_local_to_scene = false
	self.resource_name = _CLASS_NAME
	self.resource_path = _PATH
	._init(self, _manager, true)
