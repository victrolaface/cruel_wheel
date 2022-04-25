tool
class_name ResourceDatabase extends Resource

# properties
export(bool) var enabled setget , get_enabled
export(bool) var first_initialization setget , get_first_initialization
export(bool) var has_item_type setget , get_has_item_type
export(bool) var has_table_type setget , get_has_table_type
export(bool) var has_db_path setget , get_has_db_path
export(String) var table_type setget set_table_type, get_table_type
export(String) var item_type setget set_item_type, get_item_type
export(String) var db_path setget set_db_path, get_db_path

# fields
var _data = {
	"name": "",
	"manager_ref": null,
	"self_ref": null,
	"base_class_names": ["ResourceDatabase", "Resource"],
	"table_type": "",
	"item_type": "",
	"db_path": "",
	"db": null,
	"state":
	{
		"first_init": true,
		"has_db_path": true,
		"has_name": false,
		"has_manager_ref": false,
		"has_self_ref": false,
		"has_base_class_names": false,
		"has_item_type": false,
		"has_table_type": false,
		"has_db": false,
		"cached": false,
		"initialized": false,
		"saved": false,
		"enabled": false
	}
}

const _EN_DB_ERROR = "cannot enable database."


# public inherited methods
func is_class(_class: String):
	var is_base_class = false
	for b in _data.base_class_names:
		is_base_class = _class == b
		if is_base_class:
			break
	return _class == _data.name && is_base_class


func get_class():
	return _data.name


# private inherited methods
func _init(_self_ref = null, _manager = null):
	_data.self_ref = _self_ref
	_data.state.has_self_ref = not _data.self_ref == null
	_data.name = _data.self_ref.resource_name()
	_data.state.has_name = StringUtility.is_valid(_data.name)
	_data.state.has_base_class_names = _data.state.has_name
	if _data.state.has_base_class_names:
		_data.base_class_names.append(_data.name)
	_data.manager_ref = _manager
	_data.state.has_manager_ref = not _data.manager_ref == null
	if _data.has_self_ref:
		var ds = _data.state
		var sr = _data.self_ref
		_data.item_type = _on_init_has(ds.has_item_type, sr.has_item_type, sr.item_type)
		_data.state.has_item_type = _set_has_item_type(_data.item_type)
		_data.table_type = _on_init_has(ds.has_table_type, sr.has_table_type, sr.table_type)
		_data.state.has_table_type = _set_has_table_type(_data.table_type)
		_data.db_path = _on_init_has(ds.has_db_path, sr.has_db_path, sr.db_path)
		_data.state.has_db_path = _set_has_db_path(_data.db_path)
	if _can_load_db():
		var loaded = ResourceLoader.load(_data.db_path)
		var class_names = ClassType.from_name(_data.item_type).get_inheritors_list()
		var class_names_amt = class_names.size()
		var has_class_names = class_names_amt > 0
		var first_init = loaded.first_initialization
		if loaded == null or first_init:
			_data.db = ClassType.from_name(_data.table_type)
			_data.db._init()
			var is_db = not _data.db == null
			if first_init && _data.db.init_from_manager(_data.self_ref, _data.manager_ref):
				is_db = is_db && _data.db.enabled && _data.db.get_class() == _data.table_type
			var classes = [_data.table_type, _data.base_class_names[0], _data.base_class_names[1]]
			var is_class = false
			for c in classes:
				is_class = _data.db.is_class(c)
				if not is_class:
					break
			if has_class_names:
				if is_db:
					if is_class:
						var added_valid = _init_added_valid(class_names_amt, class_names)
						_data.state.has_db = _data.db.has_items && added_valid
						_init_on_has_db(first_init)
					else:
						_on_warning("database not of class type.", true)
				else:
					_on_cannot_enable_warning(true)
			else:
				_on_warning("cannot find items of class type for database.", true)
		else:
			_data.db = loaded.db
			if _data.db.enable(_data.self_ref, _data.manager_ref):
				_init_validate(false, false, has_class_names, class_names)
			else:
				_on_cannot_enable_warning()
				if _data.db.remove_disabled():
					_init_validate(false, false, has_class_names, class_names)
				else:
					_on_warning("cannot remove disabled items from database.", false)
					_init_reset_db(false, has_class_names, class_names)


# public methods
func disable():
	if _data.state.enabled:
		if _data.db.disable():
			_data.manager_ref = null
			_data.self_ref = null
			_data.state.has_db_path = false
			_data.state.has_name = false
			_data.state.has_self_ref = false
			_data.state.has_base_class_names = false
			_data.state.has_item_type = false
			_data.state.has_table_type = false
			_data.state.has_db = false
			_data.state.cached = false
			_data.state.initialized = false
			_data.state.enabled = false
			_data.state.saved = true
			if ResourceSaver.save(_data.db_path, self):
				_data.state.saved = false
			else:
				_on_cannot_save_warning()
		else:
			_on_warning("cannot disable database.", false)
	return not _data.state.enabled


# private helper methods
func _on_init(_push_err = false, _has_class_names = false, _class_names = null):
	if _push_err:
		push_error(_EN_DB_ERROR)
	if _has_class_names:
		var added_valid = false
		var proc_added = false
		var rem_valid = false
		var proc_rem = false
		if not _data.db.has_keys(_class_names):
			var idx_to_keep = []
			var idx = 0
			for n in _class_names:
				if not _data.db.has_key(n):
					idx_to_keep.append(idx)
				idx = idx + 1
			if idx_to_keep.count() > 0:
				var names_to_keep = []
				for i in idx_to_keep:
					names_to_keep.append(_class_names[i])
				if names_to_keep.count() > 0:
					_class_names = PoolStringArray(names_to_keep)
					var class_names_amt = _class_names.size()
					if class_names_amt > 0:
						added_valid = _init_added_valid(class_names_amt, _class_names)
						if not added_valid:
							_on_added_invalid_warning()
						proc_added = true
		if _data.db.has_keys_sans(_class_names):
			var init_amt = _data.db.items_amount
			var keys_sans = _data.db.keys_sans(_class_names)
			var keys_sans_amt = keys_sans.size()
			if keys_sans_amt > 0 && _data.db.remove_keys(keys_sans):
				var rem_amt = init_amt - keys_sans_amt
				rem_valid = _data.db.items_amount == rem_amt
				proc_rem = true
		var proc_added_valid = proc_added && added_valid
		var proc_rem_valid = proc_rem && rem_valid
		var proc_added_rem_valid = proc_added_valid && proc_rem_valid
		var sans_rem_valid = not proc_rem && not rem_valid
		var sans_added_valid = not proc_added && not added_valid
		var init_valid = sans_added_valid && sans_rem_valid
		var added_sans_rem_valid = proc_added_valid && sans_rem_valid
		var rem_sans_added_valid = proc_rem_valid && sans_added_valid
		var db_valid = init_valid or proc_added_rem_valid or added_sans_rem_valid or rem_sans_added_valid
		_data.state.has_db = _data.db.has_items && db_valid
		_init_on_has_db()


func _init_added_valid(_to_add_amt = 0, _class_names = null):
	var added_valid = false
	var init_amt = _data.db.items_amount
	var added_amt = 0
	for n in _class_names:
		var i = ClassType.from_name(n)
		i._init()
		if i.init_from_manager(_data.self_ref, _data.manager_ref):
			if i.enabled && _data.db.add(i.name, i):
				added_amt = added_amt + 1
			else:
				_on_warning("cannot add item to database.", false)
	var init_to_add_amt = init_amt + _to_add_amt
	var init_added_amt = init_amt + added_amt
	var amts = [init_to_add_amt, init_added_amt, added_amt]
	for amt in amts:
		added_valid = _data.db.items_amount == amt
		if not added_valid:
			_on_warning("cannot validate amount of added items to database.", false)
			break
	return added_valid


func _init_validate(_from_rem_invalid = false, _from_rem_all = false, _has_class_names = false, _class_names = null):
	if _data.db.validate():
		_on_init(false, _has_class_names, _class_names)
	else:
		_on_warning("cannot validate database.", false)
		if _from_rem_all:
			_on_init(_from_rem_all)
		elif _from_rem_invalid:
			_init_reset_db(_from_rem_invalid, _has_class_names, _class_names)
		if _data.db.remove_invalid():
			_from_rem_invalid = true
			_init_validate(_from_rem_invalid, false, _has_class_names, _class_names)
		else:
			_on_warning("cannot remove invalid items from database.", false)
			_init_reset_db(true, _has_class_names, _class_names)


func _init_reset_db(_reset_db = false, _has_class_names = false, _class_names = null):
	if not _reset_db:
		_reset_db = not _has_class_names && _data.db.items_amount > 0
	if _reset_db:
		if _data.db.remove_all():
			_init_validate(false, true, _has_class_names, _class_names)
		else:
			_on_warning("cannot remove all invalid items from database.", true)


func _init_on_has_db(_first_init = false):
	if _data.state.has_db:
		_data.state.first_init = not _first_init if _first_init else _first_init
		_data.state.cached = _data.state.has_db
		_data.state.initialized = _data.state.cached
		_data.state.enabled = _data.state.initialized
		if _data.state.enabled:
			_data.state.saved = ResourceSaver.save(_data.path, self)
			if not _data.state.saved:
				_on_cannot_save_warning(true)
		else:
			_on_cannot_enable_warning(true)
	else:
		_on_added_invalid_warning(true)


func _can_load_db():
	return (
		_data.state.has_self_ref
		&& _data.state.has_name
		&& _data.state.has_base_class_names
		&& _data.state.has_manager_ref
		&& _data.manager_ref.initialized
		&& _data.state.has_item_type
		&& _data.state.has_table_type
		&& _data.state.has_db_path
	)


func _on_init_has(_has_item = false, _self_has_item = false, _item = null):
	var item = null
	if not _has_item && _self_has_item:
		item = _item
	return item


func _set_has_item_type(_item_type = ""):
	_data.state.has_item_type = StringUtility.is_valid(_item_type)


func _set_has_table_type(_table_type = ""):
	_data.state.has_table_type = StringUtility.is_valid(_table_type)


func _set_has_db_path(_db_path = ""):
	_data.state.has_db_path = PathUtility.is_valid(_db_path)


func _on_warning(_message = "", _push_err = true):
	push_warning(_message)
	if _push_err:
		_on_init(_push_err)


func _on_cannot_save_warning(_push_err = false):
	_on_warning("cannot save database", _push_err)


func _on_cannot_enable_warning(_push_err = false):
	_on_warning(_EN_DB_ERROR, _push_err)


func _on_added_invalid_warning(_push_err = false):
	_on_warning("cannot validate added items of class type to database.", _push_err)


# setters, getters functions
func get_enabled():
	return _data.state.enabled


func get_first_initialization():
	return _data.state.first_init


func get_item_type():
	return _data.item_type


func set_item_type(_item_type = ""):
	_data.item_type = _item_type


func get_has_item_type():
	return _data.state.has_item_type


func get_has_table_type():
	return _data.state.has_table_type


func set_table_type(_table_type = ""):
	_data.table_type = _table_type
	_set_has_table_type(_table_type)


func get_table_type():
	return _data.table_type


func set_db_path(_db_path):
	_data.db_path = _db_path
	_set_has_db_path(_db_path)


func get_db_path():
	return _data.db_path


func get_has_db_path():
	return _data.state.has_db_path
