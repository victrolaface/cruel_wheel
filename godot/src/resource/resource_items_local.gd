class_name ResourceItemsLocal

var _i = {
	"ids": PoolIntArray(),
	"amt": 0,
}


func _init(_id = 0):
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
