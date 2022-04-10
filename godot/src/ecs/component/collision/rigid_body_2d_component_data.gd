"""
tool
extends Resource
class_name RigidBody2dComponentData

signal received_rigid_body
signal received_collider
signal rigid_body_changed
signal rigid_body_predelete
signal collider_changed
signal collider_predelete
signal rigid_body_deleted
signal collider_deleted

export(String) var component_name
export(Dictionary) var modes
export(Dictionary) var ccd_modes
export(Dictionary) var nodes
export(Dictionary) var entered_bodies_by_id
export(Dictionary) var entered_body_shapes_by_id
export(Dictionary) var connected
export(Dictionary) var state

const _MODES = {"RIGID": 0, "STATIC": 1, "CHARACTER": 2, "KINEMATIC": 3}
const _CCD_MODES = {"DISABLED": 0, "CAST_RAY": 1, "CAST_SHAPE": 2}
const _RB2D_NAME = "RigidBody2D"
const _COL_NAME = "CollisionBody2D"

const signals_oneshot = [
	"received_rigid_body",
	"received_collider",
	"rigid_body_predelete",
	"collider_predelete",
	"rigid_body_deleted",
	"collider_deleted"
]

const methods_oneshot = [
	"_receive_rigid_body",
	"_receive_collider",
	"_predelete_rigid_body",
	"_predelete_collider",
	"_delete_rigid_body",
	"_delete_collider"
]

const signals_deferred = [
	"rigid_body_changed",
	"collider_changed"
]

const methods_deferred = [
	"_change_rigid_body",
	"_change_collider"
]
var util = preload("res://src/util/signal/signal_util.gd")


func _init():
	resource_local_to_scene = true
	component_name = _RB2D_NAME
	modes = _MODES
	ccd_modes = _CCD_MODES
	nodes = {"rigid_body": null, "collider": null}
	entered_bodies_by_id = {}
	entered_body_shapes_by_id = {}
	connected = {
		"received_rigid_body": false,
		"received_collider": false,
		"rigid_body_changed": false,
		"rigid_body_predelete": false,
		"collider_changed": false,
		"collider_predelete": false,
		"rigid_body_deleted": false,
		"collider_deleted": false,
		"body_entered": false,
		"body_exited": false,
		"body_shape_entered": false,
		"body_shape_exited": false,
		"sleeping_state_changed": false
	}
	state = {
		"has_rigid_body": false,
		"has_collider": false,
		"bodies_entered": false,
		"body_shapes_entered": false,
		"sleeping": false
	}
	connected.received_rigid_body = util.connected(
		self, false, "received_rigid_body", self, "_receive_rigid_body", [], CONNECT_ONESHOT
	)
	connected.received_collider = util.connected(
		self, false, "received_collider", self, "_receive_collider", [], CONNECT_ONESHOT
	)
	connected.rigid_body_predelete = util.connected(
		self, false, "rigid_body_predelete", self, "_predelete_rigid_body", [], CONNECT_ONESHOT
	)
	connected.collider_predelete = util.connected(
		self, false, "collider_predelete", self, "_predelete_collider", [], CONNECT_ONESHOT
	)
	connected.rigid_body_deleted = util.connected(
		self, false, "rigid_body_deleted", self, "_delete_rigid_body", [], CONNECT_ONESHOT
	)
	connected.collider_deleted = util.connected(
		self, false, "collider_deleted", self, "_delete_collider", [], CONNECT_ONESHOT
	)
	#connected.received_rigid_body = connect(
	#	"received_rigid_body", self, "_receive_rigid_body", [], CONNECT_ONESHOT
	#)
	#connected.received_collider = connect(
	#	"received_collider", self, "_receive_collider", [], CONNECT_ONESHOT
	#)
	#connected.rigid_body_predelete = connect(Object.NOTIFICATION_PREDELETE, self, "_predelete_rigid_body", [], CONNECT_ONESHOT)
	#connected.rigid_body_predelete = connect("collider_predelete", self, "_predelete_collider", [], CONNECT_ONESHOT)


func initialize(_rigid_body: RigidBody2D):
	if nodes.rigid_body != null || _rigid_body == null:
		return
	nodes.rigid_body = _rigid_body
	if nodes.rigid_body == null || not nodes.rigid_body.has_node("./CollisionShape2D"):
		return
	nodes.collider = nodes.rigid_body.get_node("CollisionShape2D")
	if nodes.collider == null:
		nodes.rigid_body = null
		return

	#if connected.received_rigid_body:
	#emit_signal("received_rigid_body")
	#elif not is_connected("received_rigid_body", self, "_receive_rigid_body"):
	#connected.received_rigid_body = connect(
	#	"received_rigid_body", self, "_receive_rigid_body", [], CONNECT_ONESHOT
	#)
	#assert(connected.received_rigid_body, "cannot connect to received_rigid_body signal")
	#	emit_signal("received_rigid_body")
	#if nodes.rigid_body.has_node("./CollisionShape2D"):
	#	nodes.collider = nodes.rigid_body.get_node("CollisionShape2D")
	#	if nodes.collider == null:
	#		nodes.rigid_body = null
	#		return
	#connected.received_collider = SignalUtility.connected(self, connected.received_collider, "received_collider", self, "_receive_collider", [], CONNECT_ONESHOT)
	#if connected.received_collider:
	#	emit_signal("received_collider")
	#elif not is_connected("received_collider", self, "_receive_collider"):
	#	connected.received_collider = connect(
	#		"received_collider", self, "_receive_collider", [], CONNECT_ONESHOT
	#	)
	#	assert(connected.received_collider, "cannot connect to received_collider signal")
	#	emit_signal("received_collider")
	if state.has_rigid_body && state.has_collider:
		connected.rigid_body_changed = SignalUtility.connected(
			self,
			connected.rigid_body_changed,
			"script_changed",
			nodes.rigid_body,
			"_change_rigid_body"
		)
		connected.collider_changed = SignalUtility.connected(
			self, connected.collider_changed, "script_changed", nodes.collider, "_change_collider"
		)
		#_connect_collider_changed()

		#_connect_rigid_body_predelete()
		#_connect_collider_predelete()


func _connect_rigid_body_changed(
	_signal = "script_changed",
	_method = "_change_rigid_body",
	_obj = nodes.rigid_body,
	_flag = CONNECT_DEFERRED
):
	if _not_connected(connected.rigid_body_changed, _signal, _method, _obj):
		connected.rigid_body_changed = _connected(_signal, _method, _obj, _flag)


func _connect_collider_changed(
	_s = "script_changed", _m = "_change_collider", _o = nodes.collider, _f = CONNECT_DEFERRED
):
	if _not_connected(connected.collider_changed, _s, _m, _o):
		connected.collider_changed = _connected(_s, _m, _o, _f)


func _connect_rigid_body_predelete(_s = "rigid_body_predelete", _m = "predelete_rigid_body"):
	if _not_connected(connected.rigid_body_predelete, _s, _m):
		connected.rigid_body_predelete = _connected(_s, _m)
		assert(connected.rigid_body_predelete, "cannot connect to rigid_body_predelete signal")


func _connect_collider_predelete(_s = "collider_predelete", _m = "_predelete_collider"):
	if _not_connected(connected.collider_predelete, _s, _m):
		connected.collider_predelete = _connected(_s, _m)
		assert(connected.collider_predelete, "cannot connect to collider_predelete signal")


func _not_connected(_connected: bool, _s: String, _m: String, _o = self):
	return not _connected && not is_connected(_s, _o, _m)


func _connected(_s: String, _m: String, _o = self, _f = CONNECT_ONESHOT):
	return connect(_s, _o, _m, [], _f)


func _receive_rigid_body():
	state.has_rigid_body = true


func _receive_collider():
	state.has_collider = true


func _change_rigid_body():
	if nodes.rigid_body.is_queued_for_deletion() || nodes.rigid_body == null:
		_delete_rigid_body()


func _change_collider():
	if nodes.collider.is_queued_for_deletion() || nodes.collider == null:
		_delete_collider()


func _predelete_rigid_body():
	connected.rigid_body_predelete = false
	state.has_rigid_body = false
	nodes.rigid_body = null
	if _delete(nodes.collider):
		_delete_collider()


func _predelete_collider():
	connected.collider_predelete = false
	state.has_collider = false
	nodes.collider = null
	if _delete(nodes.rigid_body):
		_delete_rigid_body()


func _delete(_obj: Object):
	return (_obj != null && _obj.is_queued_for_deletion()) || _obj == null


func _delete_rigid_body():
	_connect_rigid_body_predelete()
	connected.rigid_body_changed = false
	emit_signal("rigid_body_predelete")


func _delete_collider():
	_connect_collider_predelete()
	connected.collider_changed = false
	emit_signal("collider_predelete")
"""
