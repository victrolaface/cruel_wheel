"""
class_name EntityUtility


static func is_params_valid(_self_ref, _id, _entity_mgr_ref, _components):
	return (
		not _self_ref == null
		&& _self_ref.is_class("Entity")
		&& _id > 0
		&& not _entity_mgr_ref == null
		&& not _components == null
	)
	#_data.self_ref == null && _data.id > 0 && not _data.entity_mgr_ref == null && not _data.components == null
"""
