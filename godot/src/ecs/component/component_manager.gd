"""
class_name ComponentManager extends Resource

signal received_entity
signal received_entity_id
signal added_components_to_be_added_queue
signal added_components_to_be_enabled_queue
signal added_components_to_be_disabled_queue
signal added_components_to_be_destroyed_queue
signal added_components
signal enabled_components
signal updated_components
signal disabled_components
signal destroyed_components
signal initialized
signal destroyed

export(Resource) var components setget , get_components

var data: Dictionary
#var callbacks: Dictionary
#var class_type: ClassType

func _init(_ref_entity = null, _entity_id = 0, _transform2D_component = null, _transform_component = null).():
	if not resource_local_to_scene:
		resource_local_to_scene = true

	var ent = SignalUtility.is_self_connect_valid("received_entity", self, "_on_received_entity", CONNECT_ONESHOT)
	var ent_id = SignalUtility.is_self_connect_valid("received_entity_id", self, "_on_received_entity_id", CONNECT_ONESHOT)
	var add_q = SignalUtility.is_self_connect_valid(
		"added_components_to_be_added_queue", self, "_on_added_components_to_be_added_queue", CONNECT_DEFERRED
	)
	var enbl_q = SignalUtility.is_self_connect_valid(
		"added_components_to_be_enabled_queue", self, "_on_added_components_to_be_enabled_queue", CONNECT_DEFERRED
	)
	var dsbl_q = SignalUtility.is_self_connect_valid(
		"added_components_to_be_disabled_queue", self, "_on_added_components_to_be_disabled_queue", CONNECT_DEFERRED
	)
	var dstr_q = SignalUtility.is_self_connect_valid(
		"added_components_to_be_destroyed_queue", self, "_on_added_components_to_be_destroyed_queue", CONNECT_DEFERRED
	)
	var add_cmpnts = SignalUtility.is_self_connect_valid("added_components", self, "_on_added_components", CONNECT_DEFERRED)
	var enbl_cmpnts = SignalUtility.is_self_connect_valid(
		"enabled_components", self, "_on_enabled_components", CONNECT_DEFERRED
	)
	var updt_cmpnts = SignalUtility.is_self_connect_valid(
		"updated_components", self, "_on_updated_components", CONNECT_DEFERRED
	)
	var dsbl_cmpnts = SignalUtility.is_self_connect_valid(
		"disabled_components", self, "_on_disabled_components", CONNECT_DEFERRED
	)
	var dstr_cmpnts = SignalUtility.is_self_connect_valid(
		"destroyed_components", self, "_on_destroyed_components", CONNECT_DEFERRED
	)
	var init = SignalUtility.is_self_connect_valid("is_initialized", self, "_on_initialized", CONNECT_ONESHOT)
	var dstr = SignalUtility.is_self_connect_valid("is_destroyed", self, "_on_destroyed", CONNECT_ONESHOT)

	data = {
		"ref_entity": _ref_entity,
		"entity_id": _entity_id,
		"callbacks":,
		"class_type":,
		"components": ComponentSet.new(),
		"to_be_added": ComponentSet.new(),
		"to_be_enabled": ComponentSet.new(),
		"to_be_disabled": ComponentSet.new(),
		"to_be_destroyed": ComponentSet.new(),
		"amount": 0,
		"to_be_added_amount": 0,
		"to_be_enabled_amount": 0,
		"to_be_disabled_amount": 0,
		"to_be_destroyed_amount": 0,
		"state":
		{
			"received_entity_connected": ent,
			"received_entity_id_connected": ent_id,
			"added_components_to_be_added_queue_connected": add_q,
			"added_components_to_be_enabled_queue_connected": enbl_q,
			"added_components_to_be_disabled_queue_connected": dsbl_q,
			"added_components_to_be_destroyed_queue_connected": dstr_q,
			"added_components_connected": add_cmpnts,
			"enabled_components_connected": enbl_cmpnts,
			"updated_components_connected": updt_cmpnts,
			"disabled_components_connected": dsbl_cmpnts,
			"destroyed_components_connected": dstr_cmpnts,
			"initialized_connected": init,
			"destroyed_connected": dstr,
			"has_entity": false,
			"has_entity_id": false,
			"has_components": false,
			"updating_components": false,
			"adding_components": false,
			"enabling_components": false,
			"disabling_components": false,
			"destroying_components": false,
			"initialized": false,
			"destroyed": false
		}
	}

	var init_valid = (
		ObjectUtility.is_valid(data.ref_entity)
		&& EntityUtility.is_id_valid(data.entity_id)
		&& data.state.received_entity_connected
		&& data.state.received_entity_id
		&& data.state.added_components_to_be_added_queue_connected
		&& data.state.added_components_to_be_enabled_queue_connected
		&& data.state.added_components_to_be_disabled_queue_connected
		&& data.state.added_components_to_be_destroyed_queue_connected
		&& data.state.added_components_connected
		&& data.state.enabled_components_connected
		&& data.state.destroyed_components_connected
		&& data.state.removed_components_connected
		&& data.state.initialized_connected
		&& data.state.destroyed_connected
	)
	if init_valid:
		add(_transform2D_component)
		add(_transform_component)
	#if ComponentUtility.is_valid(_transform2D_component):

	#elif ComponentUtility.is_valid(_transform_component):

	#dirty = not dirty

	#cmpnt_data.state.has_components = not dirty
	#cmpnt_data.components["Transform2DComponent"]
	#set_base_type(Component)
	#if is_type_readonly():
	#	set_type_readonly(true)

	#self.init()
	#storage = ResourceCollection.new()
	#storage.set_base_type("Component")
	#storage.set_type_readonly(true)


#func get():
func has(_component_name: String):
	pass#if data.

func _on_added_component():
	pass
	#cmpnt_data.components_amount = cmpnt_data.components_amount + 1
	#$if not cmpnt_data.state.has_components:
	#	cmpnt_data.state.has_components = true


func get_components():
	pass
	#return self


func add(_component = null):
	if ComponentUtility.is_valid(_component):
		pass
		# data.to_be_added_queue
		# var cmpnt_name = _component.get_class()
	#pass

func enable():
	pass


func disable():
	pass


func destroy():
	pass


func clear():
	pass


func remove():
	pass

"""
