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


func add(_val = null, _id = 0, _validated = false):
	var added = false
	#if not _validated:
	if _add(_val, _id, _validated):
		var key = _val.get_class()
		var id = _val.id
		if _on_add(key, id):
			added = .add(id, _val, true)
	return added


func remove(_key = "", _id = 0):
	var rem = false
	rem = .remove(_id)
	return rem

	#null)


# private helper methods
func _has_key(_key = ""):
	return _l.items.has(_key)


func _add(_val = null, _id = 0, _validated = false):
	var can_add = false
	if self.enabled:
		var valid = _validated
		if not valid:
			valid = .item_is_valid(_val)
		if valid:
			var key = _val.get_class()
			var id = _id if _validated else _val.id
			if .str_is_valid(key) && .id_is_valid(id) && _val.local && _val.has_id && _val.id == id && _val.enabled:
				can_add = not self.has_items
				if not can_add:
					can_add = not can_add if not _has_key(key) else not _l.items[key].has(id)
	return can_add


func _on_add(_key = "", _id = 0):
	var added = false
	var itm = null
	if _has_key(_key):
		itm = _l.items[_key]
		if not itm.has(_id):
			added = itm.add(_id)
	else:
		itm = LocalResourceItem.new()
		added = itm.init(_id)
	if added:
		_l.items[_key] = itm
	return added


class LocalResourceItem:
	var _i = {
		"ids": PoolIntArray(),
		"amt": 0,
	}

	func init(_id = 0):
		_i.ids.empty()
		return add(_id)

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
		if .id_is_valid(_id) && not has(_id):
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
