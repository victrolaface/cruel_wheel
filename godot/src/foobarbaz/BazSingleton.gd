tool
class_name BazSingleton extends Singleton

const _CLASS_NAME = "BazSingleton"


func _init(_mgr = null):
	._init(_CLASS_NAME, self, _mgr)
