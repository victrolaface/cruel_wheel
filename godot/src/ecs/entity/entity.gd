tool
class_name Entity extends Node

# signals
# warning-ignore-all:UNUSED_SIGNAL
#signal event_manager_req_sub
#signal event_manager_req_unsub

# fields
#enum _SIGNAL_TYPE { NONE = 0, EV_MGR_REQ_SUB = 1, EV_MGR_REQ_UNSUB = 2 }
var _data = {}


# private inherited methods
func _init():
	_enable()
	
func _enable():
	if not _data.state.enabled:
		_on_init(true)
func _disable():
	if _data.state.enabled:
		_on_init(false)

func _ready():
	_enable()
	

func _enter_tree():
	_enable()
	

func _notification(_n):
	match _n:
		NOTIFICATION_POST_ENTER_TREE:
			_enable()
		NOTIFICATION_POSTINITIALIZE:
			_enable()
		NOTIFICATION_PREDELETE:
			_disable()
		NOTIFICATION_WM_QUIT_REQUEST:
			_disable()

func _process(_delta):
	_enable()
	

func _physics_process(_delta):
	_enable()
	

# private helper methods
func _on_init(_do_init = true):
	_data = {
		"event_manager_ref": null,
		"state":
		{
			"has_event_manager_ref": false,
			"enabled": false,
			"event_manager_req_sub_connected": false,
			"event_manager_req_unsub_connected": false,
		}
	}
	if _do_init:
		_data.event_manager_ref = EventManager
		_data.state.has_event_manager_ref = not _data.event_manager_ref == null
		_data.state.enabled = _data.state.has_event_manager_ref
		pass
		#if _data.state.enabled:

	
"""	
func _connect_signals(_connect=true):
	if _data.state.has_event_manager_ref:
		var all_connected_or_disconnected = false
		var connecting_or_disconnecting = true
		var signal_type = _SIGNAL_TYPE.NONE
		var signal_name = ""
		var signal_func = ""
		var obj_to_connect = null
		while connecting_or_disconnecting:
			var on_connect_or_disconnect = true
			match signal_type:
				_SIGNAL_TYPE.NONE:
					signal_type = _SIGNAL_TYPE.EV_MGR_REQ_SUB
					signal_name = "request_subscribers"
					signal_func = "_on_event_manager_req_sub"
					obj_to_connect = _data.event_manager_ref
				_SIGNAL_TYPE.EV_MGR_REQ_SUB:
					signal_type = _SIGNAL_TYPE.EV_MGR_REQ_UNSUB
					signal_name = "request_unsubscribe"
					signal_func = "_on_event_manager_req_unsub"
					obj_to_connect = _data.event_manager_ref
				_SIGNAL_TYPE.EV_MGR_REQ_UNSUB:
					signal_type = _SIGNAL_TYPE.NONE
			var signal_type_is_none = signal_type == _SIGNAL_TYPE.NONE
			all_connected_or_disconnected = signal_type_is_none
			connecting_or_disconnecting = not signal_type_is_none
			var is_connected = is_connected(signal_name, obj_to_connect, signal_func)
			if _connect:
				if not is_connected:
					if connect()
				#var is_connected = false
				#is_connected = 
				#pass
			elif #is_connected(signal_type, self, signal_func):
				# do disconnect
				pass
			#false
				

"""
#extends Node#ResourceItem
#var #_entity = ResourceItem
"""
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
