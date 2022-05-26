tool
class_name RecyclableItems extends Resource

# properties
export(int) var to_recycle_amt setget , get_to_recycle_amt
export(bool) var initialized setget , get_initialized
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
			"initialized": false,
			"enabled": false,
		}
	}
	var type_valid = _str.is_valid(_type)
	var has_storage = false
	if type_valid:
		_data_internal.type = _type
		if not _storage == null && _storage.enabled && _storage.type == _type && _storage.has_to_recycle:
			_data_internal.to_recycle = _storage.to_recycle
			has_storage = _has_to_recycle()
	_data_internal.initialized = type_valid && has_storage if _has_to_recycle() else type_valid
	_data_internal.enabled = _data_internal.initialized


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


func on_disable(_res_path = "", _storage = null, _saver_flag = 0):
	var disabled = not _data_internal.state.enabled
	if not disabled:
		var do_save = false
		var saved = false
		var on_disable = false
		if not _storage == null && not _saver_flag == 0:
			if not _storage.enabled:
				_storage.enabled = not _storage.enabled
			if _storage.enabled && self.to_recycle_amt > 0:
				var added_amt = 0
				for i in self.to_recycle:
					if _storage.add_to_recycle(i):
						added_amt = _int.incr(added_amt)
				do_save = added_amt == self.to_recycle_amt
				if not do_save:
					var storage_amt = _storage.to_recycle_amt + (self.to_recycle_amt - added_amt)
					_storage.to_recycle_amt = storage_amt
					do_save = _storage.to_recycle_amt == storage_amt
			if do_save:
				saved = ResourceSaver.save(_res_path, _storage, _saver_flag)
		_data_internal.to_recycle.clear()
		if not _has_to_recycle():
			_data_internal.type = ""
			_data_internal.state.initialized = not _data_internal.state.initialized
			_data_internal.state.enabled = not _data_internal.state.enabled
		on_disable = not _data_internal.state.enabled
		if on_disable:
			disabled = on_disable && saved if do_save else on_disable
	return disabled


# private helper methods
func _has_to_recycle():
	return self.to_recycle_amt > 0


# setters, getters functions
func get_to_recycle_amt():
	return _data_internal.to_recycle.size()


func get_initialized():
	return _data_internal.state.initialized


func get_enabled():
	return _data_internal.state.enabled


func get_has_to_recycle():
	return _has_to_recycle()


func get_to_recycle():
	var to_rec = []
	if _has_to_recycle():
		to_rec = _data_internal.to_recycle
	return to_rec
