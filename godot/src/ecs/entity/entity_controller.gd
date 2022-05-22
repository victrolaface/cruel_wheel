"""
extends Node#ResourceItem

#var #_entity = ResourceItem
var _e = {
	"entity": ResourceItem,
	"state": "",
	"events_manager_ref": null,
}

var _obj = ObjectUtility

func _init():
	if not _obj.is_valid(_e.events_manager_ref):
		EventsManager.add_listener()
	#_entity._init()

func _ready():

func _process():

func _physics_process(_delta):
"""
