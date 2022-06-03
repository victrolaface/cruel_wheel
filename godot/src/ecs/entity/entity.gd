tool
class_name Entity extends Node

# fields
enum _EVENTS { NONE = 0, EV_MGR_SUB = 1, REQ_ID = 2, REC_ID = 3, EV_MGR_UNSUB = 4 }

const _ID = "id"
const _ON_PRE = "_on_"
const _REQ_PRE = "request_"
const _REC_PRE = "receive_"
const _EV_MGR = "EventManager"
const _REQ_SUBS = _REQ_PRE + "subscribers"
const _REQ_UNSUB = _REQ_PRE + "unsubscribe"
const _ON_EV_MGR_PRE = _ON_PRE + "event_mgr_"
const _REQ_ID = _REQ_PRE + _ID
const _REC_ID = _REC_PRE + _ID

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
			"ev_mgr_req_sub_connected": false,
			"ev_mgr_req_unsub_connected": false,
			"req_id_connected": false,
			"rec_id_connected": false,
		}
	}
	if _do_init:
		_data.event_manager_ref = EventManager
		_data.state.has_event_manager_ref = not _data.event_manager_ref == null
		_data.state.enabled = (
			_data.state.has_event_manager_ref
			&& _subscribe(_EVENTS.EV_MGR_SUB)
			&& _subscribe(_EVENTS.REQ_ID)
			&& _subscribe(_EVENTS.EV_MGR_UNSUB)
		)


func _subscribe(_event_type = _EVENTS.NONE):
	var subscribed = false
	match _event_type:
		_EVENTS.EV_MGR_SUB:
			subscribed = _on_subscribe(_REQ_SUBS, _ON_EV_MGR_PRE + _REQ_SUBS, true, _EV_MGR)
			_data.state.ev_mgr_req_sub_connected = subscribed
		_EVENTS.REQ_ID:
			subscribed = _on_subscribe(_REQ_ID, _ON_PRE + _REQ_ID, true)
			_data.state.req_id_connected = subscribed
		_EVENTS.REC_ID:
			subscribed = _on_subscribe(_REC_ID, _ON_PRE + _REC_ID, true, {})
		_EVENTS.EV_MGR_UNSUB:
			subscribed = _on_subscribe(_REQ_UNSUB, _ON_EV_MGR_PRE + _REQ_UNSUB, true, _EV_MGR)
			_data.state.ev_mgr_req_unsub_connected = subscribed
	return subscribed


func _on_subscribe(_n = "", _m = "", _os = false, _v = null):
	return (
		_data.event_manager_ref.subscribe(_n, self, _m, _os)
		if _v == null
		else _data.event_manager_ref.subscribe(_n, self, _m, _os, _v)
	)


func _disconnect(_connected = true):
	return not _connected if _connected else _connected


func _received_ev_mgr_event(_event_type = _EVENTS.NONE, _sender = ""):
	var received = not _event_type == _EVENTS.NONE && _sender == _EV_MGR
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
		_data.event_manager_ref.publish(_REQ_ID)


func _on_request_id():
	_data.state.req_id_connected = _disconnect(_data.state.req_id_connected)


func _on_receive_id(_obj = {}):
	pass


func _on_event_mgr_request_unsubscribe(_sender = ""):
	if _received_ev_mgr_event(_EVENTS.EV_MGR_UNSUB, _sender):
		# destroy self
		pass
