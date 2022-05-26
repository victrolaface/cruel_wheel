class_name RecyclableStorage extends Resource

# properties
#### rem properties, hide in inspector, change to pure funcs
export(int) var to_recycle_amt setget set_to_recycle_amt, get_to_recycle_amt
export(bool) var storage_enabled setget set_storage_enabled, get_storage_enabled
export(bool) var storage_initialized setget , get_storage_initialized
export(bool) var has_to_recycle setget , get_has_to_recycle
export(String) var type setget , get_type
export(Array, Resource) var to_recycle setget , get_to_recycle

# fields
const _MAX_STORAGE = 100000
var _int = IntUtility
var _str = StringUtility
var _data_internal = {}


# private inherited methods
func _init(_type = "", _max_amt = 0, _valid_instance = null):
	_data_internal = {
		"type": "",
		"valid_instance": null,
		"to_recycle": [],
		"to_recycle_amt": 0,
		"max_amt": _MAX_STORAGE,
		"state":
		{
			"has_valid_instance": false,
			"initialized": false,
			"enabled": false,
		}
	}
	var type_valid = _str.is_valid(_type)
	var max_valid = _max_amt > 0 && _max_amt < _MAX_STORAGE
	var inst_valid = _rec_item_valid(_valid_instance)
	if type_valid:
		_data_internal.type = _type
	if max_valid:
		_data_internal.max_amt = _max_amt
	_data_internal.has_valid_instance = inst_valid
	_data_internal.initialized = (
		type_valid && inst_valid && max_valid
		if _data_internal.max_amt == _max_amt
		else type_valid && inst_valid
	)
	_data_internal.enabled = _data_internal.initialized


# private helper methods
func _on_added(_amt = 0, _init_amt = 0):
	return _amt == _init_amt + 1


func _rec_item_valid(_item = null):
	return (
		not _item == null
		&& _item.resource_local_to_scene
		&& not _item.enabled
		&& _item.get_class() == _data_internal.type
	)


# public methods
func add_to_recycle(_item = null):
	var added = false
	if self.storage_enabled && _rec_item_valid(_item):
		var init_amt = self.to_recycle_amt
		_data_internal.to_recycle.append(_item)
		if _on_added(_data_internal.to_recycle.size(), init_amt):
			init_amt = _data_internal.to_recycle_amt
			_data_internal.to_recycle_amt = _int.incr(_data_internal.to_recycle_amt)
			added = _on_added(_data_internal.to_recycle_amt, init_amt)
	return added


# setters, getters functions
func set_to_recycle_amt(_amt = 0):
	if _amt > 0 && _amt <= _MAX_STORAGE:
		_data_internal.to_recycle_amt = _amt
		self.storage_enabled = true


func get_to_recycle_amt():
	return _data_internal.to_recycle_amt if _data_internal.state.enabled else 0


func set_storage_enabled(_enabled = false):
	if _enabled && not _data_internal.state.enabled:
		var init_to_rec_amt = _data_internal.to_recycle.size()
		var to_rec_amt = _data_internal.to_recycle_amt
		if to_rec_amt > 0 && not init_to_rec_amt == to_rec_amt:
			var idx = 0
			var amt = 0
			if init_to_rec_amt > to_rec_amt:
				var resized = []
				for i in _data_internal.to_recycle:
					resized[idx] = i
					idx = _int.incr(idx)
					amt = _int.incr(amt)
					if amt >= to_rec_amt:
						break
				_data_internal.to_recycle = resized
			elif init_to_rec_amt < to_rec_amt:
				var add = true
				idx = init_to_rec_amt
				while add:
					var i = _data_internal.valid_instance.duplicate()
					_data_internal.to_recycle[idx] = i
					amt = _int.incr(amt)
					add = not amt >= (to_rec_amt - init_to_rec_amt)
					idx = _int.incr(idx)
		if not _data_internal.state.initialized:
			_data_internal.state.initialized = _data_internal.to_recycle.size() == _data_internal.to_recycle_amt
		_data_internal.state.enabled = _data_internal.state.initialized


func get_storage_enabled():
	return true if _data_internal.state.enabled else false


func get_storage_initialized():
	return _data_internal.state.initialized if _data_internal.state.enabled else false


func get_has_to_recycle():
	return _data_internal.to_recycle_amt if _data_internal.state.enabled else false


func get_to_recycle():
	var to_rec = []
	if self.storage_enabled && self.has_to_recycle:
		to_rec = _data_internal.to_recycle
	return to_rec


func get_type():
	return _data_internal.type if _data_internal.state.enabled else ""
