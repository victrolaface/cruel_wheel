tool
class_name RecyclableItems extends Resource

# properties
export(Array, Resource) var to_recycle setget , get_to_recycle
export(bool) var has_to_recycle setget , get_has_to_recycle
export(bool) var initialized setget , get_initialized
export(bool) var enabled setget , get_enabled
export(int) var to_recycle_amt setget , get_to_recycle_amt

# fields
var _str = StringUtility
var _int = IntUtility
var _obj = ObjectUtility
var _data_internal = {}


# private inherited methods
func _init(_type = "", _to_rec = []):
	resource_local_to_scene = false
	_data_internal = {
		"to_recycle": [],
		"type": "",
		"state":
		{
			"enabled": true,
			"initialized": true,
		}
	}
	if _str.is_valid(_type):
		_data_internal.type = _type
	if _to_rec.size() > 0:
		_data_internal.to_recycle = _to_rec


# public methods
func add_to_recycled(_item = null):
	var on_add = _obj.is_valid(_item) && _item.get_class() == _data_internal.type
	if on_add:
		var init_size = self.to_recycle_amt
		_data_internal.append(_item)
		on_add = self.to_recycle_amt == init_size + 1
	return on_add


func recycled():
	var r = null
	if _has_to_recycle():
		var idx = _data_internal.size() - 1
		r = _data_internal.to_recycle.remove(idx)
	return r


func on_disable():
	if _data_internal.state.enabled:
		_data_internal.state.enabled = not _data_internal.state.enabled
	return not _data_internal.state.enabled


# private helper methods
func _has_to_recycle():
	return self.to_recycle_amt > 0


# setters, getters functions
func get_to_recycle():
	var to_rec = []
	if _has_to_recycle():
		to_rec = _data_internal.to_recycle
	return to_rec


func get_to_recycle_amt():
	return _data_internal.to_recycle.size()


func get_has_to_recycle():
	return _has_to_recycle()


func get_initialized():
	return _data_internal.state.initialized


func get_enabled():
	return _data_internal.state.enabled
