tool
class_name BarSingleton extends Singleton

const _CLASS_NAME = "BarSingleton"


func _init(_mgr = null):
	._init(_CLASS_NAME, self, _mgr, true)
