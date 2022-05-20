class_name EventManager extends Node

# signals
# warning-ignore:UNUSED_SIGNAL
signal register_event_manager

# fields
const _REG_LISTENERS_SIGNAL = "register_listeners"
const _REG_LISTENERS_SIGNAL_FUNC = "_on_register_listeners"
const _SEPERATOR = "-"
var _data = {}


# private inheritied methods
func _init():
	_on_init(true)


func _ready():
	_register_listeners()


func _enter_tree():
	_register_listeners()


func _notification(_n):
	match _n:
		NOTIFICATION_POST_ENTER_TREE:
			_register_listeners()
		NOTIFICATION_POSTINITIALIZE:
			_register_listeners()
		NOTIFICATION_PREDELETE:
			_on_init(false)
		NOTIFICATION_WM_QUIT_REQUEST:
			_on_init(false)


func _process(_delta):
	pass


func _physics_process(_delta):
	pass


# public methods
func subscribe():
	pass


func unsubscribe():
	pass


func publish():
	pass


# private helper methods
func _on_init(_do_init = false):
	pass


func _register_listeners():
	pass
