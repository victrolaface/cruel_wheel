tool
class_name ResourceValidationUtil extends Resource

static func is_valid(_has_item = false, _item = null, _cond = null):
    return not _has_item && _item != null && _item != _cond

static func is_local_valid(_is_local = false, _resource_local_to_scene = false):
    return _is_local && _resource_local_to_scene
