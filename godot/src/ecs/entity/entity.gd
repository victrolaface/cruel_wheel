tool
class_name Entity extends Node

# fields
enum _EVENTS { NONE = 0, EV_MGR_SUB = 1, REQ_ID = 2, REC_ID = 3, EV_MGR_UNSUB = 4 }

var _data = {
	"state":
	{
		"enabled": false,
	}
}


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
	_data.event_manager_ref = null
	_data.state.has_event_manager_ref = false
	_data.state.ev_mgr_req_sub_connected = false
	_data.state.ev_mgr_req_unsub_connected = false
	_data.state.req_id_connected = false
	_data.state.rec_id_connected = false
	if _do_init:
		_data.event_manager_ref = EventManager
		_data.state.has_event_manager_ref = not _data.event_manager_ref == null
		_data.state.enabled = (
			_data.state.has_event_manager_ref
			&& _on_subscribe(_EVENTS.EV_MGR_SUB)
			&& _on_subscribe(_EVENTS.REQ_ID)
			&& _on_subscribe(_EVENTS.REC_ID)
			&& _on_subscribe(_EVENTS.EV_MGR_UNSUB)
		)


func _on_subscribe(_event_type = _EVENTS.NONE):
	var subscribed = false
	match _event_type:
		_EVENTS.EV_MGR_SUB:
			_data.state.ev_mgr_req_sub_connected = _subscribe(
				"request_subscribers", "_on_event_mgr_request_subscribers", true, "EventManager"
			)
			subscribed = _data.state.ev_mgr_req_sub_connected
		_EVENTS.REQ_ID:
			_data.state.req_id_connected = _subscribe("request_id", "_on_request_id", true)
			subscribed = _data.state.req_id_connected
		_EVENTS.REC_ID:
			_data.state.rec_id_connected = _subscribe("receive_id", "_on_receive_id", true, {})
			subscribed = _data.state.rec_id_connected
		_EVENTS.EV_MGR_UNSUB:
			_data.state.ev_mgr_req_unsub_connected = _subscribe(
				"request_unsubscribe", "_on_event_mgr_request_unsubscribe", true, "EventManager"
			)
			subscribed = _data.state.ev_mgr_req_unsub_connected
	return subscribed


func _subscribe(_event_name = "", _method_name = "", _oneshot = false, _val = null):
	return (
		_data.event_manager_ref.subscribe(_event_name, self, _method_name, _oneshot, _val)
		if not _val == null
		else _data.event_manager_ref.subscribe(_event_name, self, _method_name, _oneshot)
	)


func _disconnect(_connected = true):
	return not _connected if _connected else _connected


func _received_ev_mgr_event(_event_type = _EVENTS.NONE, _sender = ""):
	var received = not _event_type == _EVENTS.NONE && _sender == "EventManager"
	if received:
		match _event_type:
			_EVENTS.EV_MGR_SUB:
				_data.state.ev_mgr_req_sub_connected = _disconnect(_data.state.ev_mgr_req_sub_connected)
				received = not _data.state.ev_mgr_req_sub_connected
			_EVENTS.EV_MGR_UNSUB:
				_data.state.ev_mgr_req_unsub_connected = _disconnect(_data.state.ev_mgr_req_unsub_connected)
				received = not _data.state.ev_mgr_req_unsub_connected
	return received


# signal callback methods
func _on_event_mgr_request_subscribers(_sender = ""):
	if _received_ev_mgr_event(_EVENTS.EV_MGR_SUB, _sender) && _data.state.req_id_connected:
		_data.event_manager_ref.publish("request_id")


func _on_request_id():
	_data.state.req_id_connected = _disconnect(_data.state.req_id_connected)


func _on_receive_id(_obj = {}):
	pass


func _on_event_mgr_request_unsubscribe(_sender = ""):
	if _received_ev_mgr_event(_EVENTS.EV_MGR_UNSUB, _sender):
		# destroy self
		pass
