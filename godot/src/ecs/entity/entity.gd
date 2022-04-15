class_name Entity extends CallbackDelegator

signal request_id
signal received_id
signal received_components
signal updated_components
signal added_components
signal enabled_components
signal disabled_components
signal destroyed_components
signal initialized
signal enabled
signal updated
signal disabled
signal destroyed

export(int) var id setget , get_id  #set_id, get_id
export(Resource) var components setget , get_components


func get_id():
	if ent_data.state.has_id:
		return ent_data.id


func get_components():
	if ent_data.state.has_components:
		return ent_data.components


func get_component(_name: String):
	if ent_data.state.has_components:
		pass


var ent_data: Dictionary


func _init():
	# request id
	var req_id = SignalUtility.is_self_connect_valid("request_id", self, "_on_request_id", CONNECT_ONESHOT)
	var rec_id = SignalUtility.is_self_connect_valid("received_id", self, "_on_received_id", CONNECT_ONESHOT)
	var rec_cmpnts = SignalUtility.is_self_connect_valid(
		"received_components", self, "_on_received_components", CONNECT_ONESHOT
	)
	var updt_cmpnts = SignalUtility.is_self_connect_valid(
		"updated_components", self, "_on_updated_components", CONNECT_DEFERRED
	)
	var added_cmpnts = SignalUtility.is_self_connect_valid(
		"added_components", self, "_on_added_components", CONNECT_DEFERRED
	)
	var enbl_cmpnts = SignalUtility.is_self_connect_valid(
		"enabled_components", self, "_on_enabled_components", CONNECT_DEFERRED
	)
	var dsbl_cmpnts = SignalUtility.is_self_connect_valid(
		"disabled_components", self, "_on_disabled_components", CONNECT_DEFERRED
	)
	var dstr_cmpnts = SignalUtility.is_self_connect_valid(
		"destroyed_components", self, "_on_destroyed_components", CONNECT_DEFERRED
	)
	var init = SignalUtility.is_self_connect_valid("initialized", self, "_on_initialized", CONNECT_ONESHOT)
	var enbl = SignalUtility.is_self_connect_valid("enabled", self, "_on_enabled", CONNECT_DEFERRED)
	#var updt = SignalUtility.is_self_connect_valid("updated", self, "_on_updated", CONNECT_DEFERRED)
	var dsbl = SignalUtility.is_self_connect_valid("disabled", self, "_on_disabled", CONNECT_DEFERRED)
	var dstr = SignalUtility.is_self_connect_valid("destroyed", self, "_on_destroyed", CONNECT_ONESHOT)
	ent_data = {
		"id": 0,
		"components": ComponentSet.new(),
		"state":
		{
			"request_id_connected": req_id,
			"received_id_connected": rec_id,
			"received_components_connected": rec_cmpnts,
			"updated_components_connected": updt_cmpnts,
			"added_components_connected": added_cmpnts,
			"enabled_components_connected": enbl_cmpnts,
			"disabled_components_connected": dsbl_cmpnts,
			"destroyed_components_connected": dstr_cmpnts,
			"initialized_connected": init,
			"enabled_connected": enbl,
			#"updated_connected": updt,
			"disabled_connected": dsbl,
			"destroyed_connected": dstr,
			"has_id": false,
			"has_components": false,
			"receiving_components": false,
			"updating_components": false,
			"adding components": false,
			"enabling components": false,
			"disabling_components": false,
			"initialized": false,
			"enabled": false,
			"destroyed": false
		}
	}

	#print("foo")
	#t_valid(_signal_name, self, null, _method, [], _flags)


func _ready():
	print("foo")
	pass


func set_id():
	pass

#func get_id():
#	pass
