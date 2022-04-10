tool
class_name ComponentManager
extends CallbackDelegator

export(int) var id = null

var _components: Dictionary = {}
var _registered_components: Dictionary = {}

func _ready():
	._ready()
