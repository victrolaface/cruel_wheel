"""
class_name ComponentUtility


static func is_valid(_component = null):
	return (
		not _component == null
		&& _component.is_type(Component.COMPONENT_TYPE)
		&& _component.get_type() == Component.COMPONENT_TYPE
	)
"""
