tool
class_name RecyclableItems extends Resource

# properties
export(int) var to_recycle_amt setget , get_to_recycle_amt
export(bool) var enabled setget , get_enabled
export(bool) var has_to_recycle setget , get_has_to_recycle
export(Array, Resource) var to_recycle setget , get_to_recycle

# fields
var _str = StringUtility
var _int = IntUtility
var _obj = ObjectUtility
var _data_internal = {}


# private inherited methods
func _init(_type = "", _storage = null):
	_data_internal = {
		"to_recycle": [],
		"type": "",
		"state":
		{
			"enabled": false,
		}
	}
	var type_valid = _str.is_valid(_type)
	var has_storage = false
	if type_valid:
		_data_internal.type = _type
		if not _storage == null && _storage.storage_enabled() && _storage.type() == _type && _storage.has_to_recycle():
			_data_internal.to_recycle = _storage.to_recycle()
			has_storage = _has_to_recycle()
	_data_internal.enabled = type_valid && has_storage if _has_to_recycle() else type_valid


# public methods
func add_to_recycled(_item = null):
	var on_add = _obj.is_valid(_item) && _item.is_class(_data_internal.type)
	if on_add:
		var init_size = _to_recycle_amt()
		_data_internal.append(_item)
		on_add = _to_recycle_amt() == init_size + 1
	return on_add


func recycled(_type = ""):
	var rec = null
	var idx = _data_internal.size() - 1
	var do_rem = false
	if _has_to_recycle():
		rec = _data_internal.to_recycle[idx]
		if not rec == null:
			if _str.is_valid(_type) && _type == _data_internal.type:
				do_rem = rec.is_class(_type)
			else:
				do_rem = rec.is_class(_data_internal.type)
		if do_rem:
			_data_internal.to_recycle.remove(idx)
	return rec


func on_disable(_res_path = "", _storage = null, _saver_flag = 0):
	var disabled = not _data_internal.state.enabled
	if not disabled:
		var do_save = false
		var saved = false
		var on_disable = false
		if not _storage == null && not _saver_flag == 0:
			if not _storage.storage_enabled():
				_storage.on_storage_enabled(true)
			if _storage.storage_enabled() && _has_to_recycle():
				var added_amt = 0
				for i in _data_internal.to_recycle:
					if _storage.add_to_recycle(i):
						added_amt = _int.incr(added_amt)
				do_save = added_amt == _to_recycle_amt()
				if not do_save:
					var storage_amt = _storage.to_recycle_amt() + (_to_recycle_amt() - added_amt)
					_storage.on_to_recycle_amt(storage_amt)
					do_save = _storage.to_recycle_amt() == storage_amt
			if do_save:
				saved = ResourceSaver.save(_res_path, _storage, _saver_flag)
		_data_internal.to_recycle.clear()
		if not _has_to_recycle():
			_data_internal.type = ""
			_data_internal.state.enabled = not _data_internal.state.enabled
		on_disable = not _data_internal.state.enabled
		if on_disable:
			disabled = on_disable && saved if do_save else on_disable
	return disabled


# private helper methods
func _has_to_recycle():
	return _to_recycle_amt() > 0 if _data_internal.state.enabled else false


func _to_recycle_amt():
	return _data_internal.to_recycle.size() if _data_internal.state.enabled else 0


# setters, getters functions
func get_to_recycle_amt():
	return _data_internal.to_recycle.size()


func get_enabled():
	return _data_internal.state.enabled


func get_has_to_recycle():
	return _has_to_recycle()


func get_to_recycle():
	return _data_internal.to_recycle if _has_to_recycle() else []
