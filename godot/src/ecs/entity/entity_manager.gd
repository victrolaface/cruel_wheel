tool
class_name EntityManager extends Node

var packed_scene: EntityPackedScene
var component_mgr: ComponentManager
var msg: MessageDispatcher


func _init():
	packed_scene = EntityPackedScene.new()
	msg = MessageDispatcher.new()
	component_mgr = null

#func _ready():
