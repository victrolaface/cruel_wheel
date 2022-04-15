class_name ComponentSet extends Resource

export(Resource) var components setget , get_components

var cmpnt_data: Dictionary


func _init(_transform2D = null, _transform = null).():
	if not resource_local_to_scene:
		resource_local_to_scene = true

	cmpnt_data = {
		"components": {},
		"components_amount": 0,
		"state":
		{
			"has_components": false,
		}
	}

	#var dirty = true
	if ComponentUtility.is_valid(_transform2D):
		add(_transform2D)
		#_on_added_component()
		#cmpnt_data.components_amount = cmpnt_data.components_amount + 1
		#dirty = not dirty
	elif ComponentUtility.is_valid(_transform):
		cmpnt_data.components["TransformComponent"] = _transform

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


func _on_added_component():
	cmpnt_data.components_amount = cmpnt_data.components_amount + 1
	if not cmpnt_data.state.has_components:
		cmpnt_data.state.has_components = true


func get_components():
	pass
	#return self


func add(_component = null):
	if ComponentUtility.is_valid(_component):
		var cmpnt_name = _component.get_class()
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
