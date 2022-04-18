tool
class_name ComponentSet extends ResourceCollection

signal removed_component
signal added_component
signal cleared_components

const COLLECTION_NAME = "Component Set"

export(Resource) var data setget , get_data

var cs_data: Dictionary


func _init():
	resource_name = COLLECTION_NAME
	cs_data = {"components": {}, "amount": 0, "state": {"has_components": false}}


func _clear():
	cs_data.clear()


func get_data():
	return cs_data


func has(_component_name: String):
	var has_cmpnt = false
	var valid = StringUtility.is_valid(_component_name)
	var has_amt = cs_data.has_components && cs_data.amount > 0
	if valid && has_amt:
		has_cmpnt = cs_data.components.has(_component_name)
	return has_cmpnt
