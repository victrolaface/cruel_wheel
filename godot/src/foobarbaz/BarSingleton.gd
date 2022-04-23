tool
class_name BarSingleton extends Singleton

const _CLASS_NAME = "BarSingleton"
const _PATH = "res://src/foobarbaz/BarSingleton.gd"


func _init():
	self.resource_name = "BarSingleton"
	self.resource_path = _PATH
	self.editor_only = true
	._init(self)
