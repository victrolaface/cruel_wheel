tool
class_name FooSingleton extends Singleton

const _CLASS_NAME = "FooSingleton"


func _init(_mgr: SingletonManager):
	._init(_CLASS_NAME, self, _mgr)
