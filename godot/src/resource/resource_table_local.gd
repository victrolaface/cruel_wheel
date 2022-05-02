tool
class_name ResourceTableLocal extends ResourceTable

enum _INSTANCE { DISABLED = 0, ENABLED = 1 }

var _l = {
	"class_names": PoolStringArray(["ResourceTableLocal"]),
	"path": "res://src/resource/resource_table_local.gd",
	"items": {},
}


func _init(_local = true, _path = "", _editor_only = false, _class_names = [], _id = 0):
	_l.class_names = .init_class_names(_class_names, _l.class_names)
	_l.item_names.empty()
	_l.ids.empty()
	var local = .init_local_param(_local, _id)
	var path = .init_path_param(_path, _l.path)
	._init(local, path, _editor_only, _l.class_names, _id)


func add(_val = null):
	var added = false
	if _add(_val):
		var key = _val.get_class()
		var id = _val.id
		if _on_add(key, id):
			added = .add_kvp(id, _val, true)
	return added


# private helper methods
func _has_key(_key = ""):
	return _l.items.has(_key)


func _add(_val = null):
	var can_add = self.enabled && .item_is_valid(_val)
	var key = _val.get_class()
	var id = _val.id
	if can_add:
		var valid_key = .str_is_valid(key)
		var valid_id = _val.local && _val.has_id && .id_is_valid(id)
		if valid_key && valid_id:
			if _has_key(key):
				can_add = not _l.items[key].has(id)
			else:
				can_add = not self.has_items
	return can_add


func _on_add(_key = "", _id = 0):
	var added = false
	if _has_key(_key):
		var tmp = _l.items[_key]
		if not tmp.has(_id):
			added = tmp.add(_id)
			if added:
				_l.items[_key] = tmp
	return added


class LocalResourceItem:
	var _i = {
		"ids": PoolIntArray(),
		"amt": 0,
	}

	func _init(_id = 0):
		_i.ids.empty()
		add(_id)

	func has(_id = 0):
		var has = false
		if _id > 0 && _i.amt > 0:
			for id in _i.ids:
				has = id == _id
				if has:
					break
		return has

	func add(_id = 0):
		var added = false
		if not has(_id):
			var tmp = _i.ids
			var amt = _i.amt + 1
			tmp.resize(amt + 1)
			tmp.set(0, _id)
			_i.ids = tmp
			_i.amt = amt
			added = true
		return added

	func remove(_id = 0):
		var removed = false
		if has(_id):
			var idx = 0
			var inv_idx = false
			for id in _i.ids:
				inv_idx = id == _id
				if inv_idx:
					break
				idx = idx + 1
			if inv_idx:
				var on_idx = idx
				var tmp = PoolIntArray()
				var amt = _i.amt - 1
				tmp.empty()
				tmp.resize(amt)
				idx = 0
				for id in _i.ids:
					if idx == on_idx:
						continue
					tmp.set(idx, id)
					idx = idx + 1
				_i.ids = PoolIntArray(tmp)
				_i.amt = amt
				removed = true
		return removed
