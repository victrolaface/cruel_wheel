class_name EntityData extends Resource

export(int) var id setget , get_id
export(Resource) var components setget , get_components
export(bool) var initialized setget , get_initialized
export(bool) var enabled setget , get_enabled

var _data = {
	"transform": null,
	"self_ref": null,
	"entity_mgr_ref": null,
	"id": 0,
	"components": null,
	"state": {"enabled": false, "destroyed": false}
}


func get_initialized():
	return EntityUtility.is_params_valid(_data.self_ref, _data.id, _data.entity_mgr_ref, _data.components)


func get_id():
	return _data.id


func get_components():
	return _data.components


func get_enabled():
	return _data.state.enabled


func _init(_self_ref = null, _id = 0, _entity_mgr_ref = null, _components = null, _enable = false):
	resource_local_to_scene = true
	_data.self_ref = _self_ref
	_data.id = _id
	_data.entity_mgr_ref = _entity_mgr_ref
	_data.components = _components
	_data.state.enabled = self.initialized && _enable


func is_class(_class: String):
	return _class == "Entity2D" or _class == "Entity3D" or _class == get_class()


func get_class():
	return "Entity"


#========================================================================
"""
class_name EntityData extends Resource

export(int) var id setget set_id, get_id
export(Resource) var components setget set_components, get_components
export(Resource) var manager setget set_manager, get_manager
export(Resource) var state setget set_state, get_state


func _init():
    resource_local_to_scene = true
    id = 0
    components = ResourceSet.new()
"""
"""
data = {
        "id": 0,
        "components": null,
        "manager": null,
        "state": {
            "request_id_connected": false,
            "received_id_connected": false,
            "initialized_connected": false,
            "updated_connected": false,
            "enabled_connected": false,
            "disabled_connected": false,
            "destroyed_connected": false,
            "has_id": false,
            "has_components": false,
            "intialized": false,
            "enabled": false,
            "destroyed": false
        }
    }
"""
#==========================================================================

"""
class_name Entity extends Node

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

export(int) var id setget set_id, get_id  #set_id, get_id
export(Resource) var components setget , get_components


func set_id(_id: int):
	data.id = _id


func get_id():
	if data.state.has_id:
		return data.id


func get_components():
	if data.state.has_components:
		return data.components


func get_component(_component_name: String):
	if data.state.has_components && data.components.has(_component_name):  #_mgr:
		pass
		#pass

var data: Dictionary
#var component_mgr: ComponentManager

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
	var dsbl = SignalUtility.is_self_connect_valid("disabled", self, "_on_disabled", CONNECT_DEFERRED)
	var dstr = SignalUtility.is_self_connect_valid("destroyed", self, "_on_destroyed", CONNECT_ONESHOT)
	var cmpnt_mgr = ComponentManager.new()
	data = {
		"id": 0,
		"component_manager": cmpnt_mgr,
		"ref_self": self,
		"ref_entity_manager": null,
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
			"disabled_connected": dsbl,
			"destroyed_connected": dstr,
			"has_id": false,
			"has_component_manager": false,
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
	if data.request_id_connected && data.received_id_connected:
		emit_signal("request_id")
"""
#component_mgr = ComponentManager.new()

#func _ready():

# component_mgr.notify("_ready")
#_notify("_ready")

#func _notify(_name: String, #on_notification

#print("foo")
#t_valid(_signal_name, self, null, _method, [], _flags)
