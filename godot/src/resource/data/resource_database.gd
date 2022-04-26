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
	"db": [],
	"db_tables_amount": 0,
	"validator":
	{
		"item": null,
		"is_valid": false,
	},
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
		"has_table": false,
		"db_init": false,
		"db_enabled": false,
		"cached": false,
		"initialized": false,
		"saved": false,
		"enabled": false
	}
}

const _EN_DB_ERROR = "cannot enable database."


# public inherited methods
func is_class(_class = ""):
	ClassNameUtility.is_class_name(_class, _data.name, _data.base_class_names)


func get_class():
	return _data.name


# private inherited methods
func _init(_self_ref = null, _manager = null):
	_data.self_ref = _self_ref
	_data.state.has_self_ref = not _data.self_ref == null
	_data.name = _data.self_ref.resource_name()
	_data.state.has_name = StringUtility.is_valid(_data.name)
	_data.state.has_base_class_names = _data.state.has_name
	_data.base_class_names = ClassNameUtility.init_base_class_names(_data.state.has_name, _data.name, _data.base_class_names)
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
		if not has_class_names:
			_on_warning("cannot find items of class type for database.", true)
		var first_init = loaded == null or loaded.first_initialization
		if first_init:
			var table_init = ClassType.from_name(_data.table_type)
			var is_table = not table_init == null
			if is_table:
				table_init._init()
				if table_init.has_self_ref && table_init.has_name:
					_data.state.db_init = table_init.init_from_manager(_data.self_ref, _data.manager_ref)
				elif table_init.has_self_ref && not table_init.has_name:
					_data.state.db_init = table_init.init_from_manager(_data.self_ref, _data.manager_ref, _data.table_type)
				_data.state.db_enabled = _data.state.db_init && table_init.enabled
				if not _data.state.db_enabled:
					_on_cannot_enable_warning(not _data.state.db_enabled)
			is_table = _data.state.db_enabled && table_init.get_class() == _data.table_type
			if not is_table:
				_on_db_not_of_class_type_warning()
				_on_cannot_enable_warning(true)
			var classes = [_data.table_type]
			for base_class_name in _data.base_class_names:
				classes.append(base_class_name)
			var is_class = false
			for c in classes:
				is_class = table_init.is_class(c)
				if not is_class:
					_on_db_not_of_class_type_warning(not is_class)
					break
			_data.validator = _init_added_valid(_data.validator, table_init, class_names_amt, class_names)
			var added_valid = _data.validator.is_valid
			if added_valid:
				table_init = _data.validator.item
			_data.state.has_table = table_init.has_items && added_valid
			_init_on_has_table(first_init, table_init)
		else:
			var init_tables_amt = loaded.db.count()
			for t in loaded.db:
				var self_ref = t.self_ref
				if t.enable(self_ref, _data.self_ref, _data.manager_ref):
					_init_validate(t, false, false, has_class_names, class_names)
				else:
					_on_cannot_enable_warning()
					if t.remove_disabled():
						_init_validate(t, false, false, has_class_names, class_names)
					else:
						_on_warning("cannot remove disabled items from database.", false)
						_init_reset_db(t, false, has_class_names, class_names)
			_data.state.has_db = _tables_amount_valid(false, init_tables_amt)
			_init_on_has_db()


# public methods
func disable():
	if _data.state.enabled:
		var disabled = false
		if _data.db.count() > 1:
			for t in _data.db:
				disabled = t.disable()
				if not disabled:
					break
		else:
			disabled = _data.db[0].disable()
		if disabled:
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
				_data.db.clear()
				_data.db = null
			else:
				_on_cannot_save_warning()
		else:
			_on_warning("cannot disable database.", false)
	return not _data.state.enabled


# private helper methods
func _on_init(_table = null, _push_err = false, _has_class_names = false, _class_names = null):
	if _push_err:
		push_error(_EN_DB_ERROR)
	elif _has_class_names:
		var added_valid = false
		var proc_added = false
		var rem_valid = false
		var proc_rem = false
		if not _table.has_keys(_class_names):
			var idx_to_keep = []
			var idx = 0
			for n in _class_names:
				if not _table.has_key(n):
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
						_data.validator = _init_added_valid(_data.validator, _table, class_names_amt, _class_names)
						added_valid = _data.validator.is_valid
						if added_valid:
							_table = _data.validator.item
						if not added_valid:
							_on_added_invalid_warning()
						proc_added = true
		if _table.has_keys_sans(_class_names):
			var init_amt = _table.items_amount
			var keys_sans = _table.keys_sans(_class_names)
			var keys_sans_amt = keys_sans.size()
			if keys_sans_amt > 0 && _table.remove_keys(keys_sans):
				var rem_amt = init_amt - keys_sans_amt
				rem_valid = _table.items_amount == rem_amt
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
		_data.state.has_db = _table.has_items && db_valid
		_init_on_has_table(false, _table)


func _init_on_has_table(_first_init = false, _table = null):
	if _data.state.has_table:
		var init_db = _data.db.count() == 0 or _data.db == null
		if _first_init:
			init_db = _first_init && _data.db.count > 0
			_data.state.first_init = not init_db
			_data.state.has_db = _tables_amount_valid(true)
		if init_db:
			_data.db = []
			_data.db.clear()
		_data.db.append(_table)
		_data.db_tables_amount = _data.db_tables_amount + 1
		if _first_init:
			_init_on_has_db()
	else:
		_on_added_invalid_warning(true)


func _init_on_has_db():
	if _data.state.has_db:
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
		_on_cannot_enable_warning(true)


func _init_added_valid(_validator = null, _table = null, _to_add_amt = 0, _class_names = null):
	var added_valid = false
	var init_amt = _table.items_amount
	var added_amt = 0
	for n in _class_names:
		var i = ClassType.from_name(n)
		i._init()
		if i.init_from_manager(_data.self_ref, _data.manager_ref):
			if i.enabled && _table.add(i.name, i):
				added_amt = added_amt + 1
			else:
				_on_warning("cannot add item to database.", false)
	var init_to_add_amt = init_amt + _to_add_amt
	var init_added_amt = init_amt + added_amt
	var amts = [init_to_add_amt, init_added_amt, added_amt]
	for amt in amts:
		added_valid = _table.items_amount == amt
		if not added_valid:
			_on_warning("cannot validate amount of added items to database.", false)
			break
	_validator.item = _table
	_validator.is_valid = added_valid
	return _validator


func _init_validate(_table = null, _from_rem = false, _from_rem_all = false, _has_class_names = false, _class_names = null):
	if _table.validate():
		_on_init(_table, false, _has_class_names, _class_names)
	else:
		_on_warning("cannot validate database.", false)
		if _from_rem_all:
			_on_init(null, _from_rem_all)
		elif _from_rem:
			_init_reset_db(_table, _from_rem, _has_class_names, _class_names)
		if _table.remove_invalid():
			_from_rem = true
			_init_validate(_table, _from_rem, false, _has_class_names, _class_names)
		else:
			_on_warning("cannot remove invalid items from database.", false)
			_init_reset_db(_table, true, _has_class_names, _class_names)


func _init_reset_db(_table = null, _reset_db = false, _has_class_names = false, _class_names = null):
	if not _reset_db:
		_reset_db = not _has_class_names && _table.items_amount > 0
	if _reset_db:
		if _table.remove_all():
			_init_validate(_table, false, true, _has_class_names, _class_names)
		else:
			_on_warning("cannot remove all invalid items from database.", true)


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


func _tables_amount_valid(_first_init = false, _init_amt = 1):
	var amt = _data.db.count()
	var t_amt = _data.db_tables_amount
	var amt_is_init = amt == _init_amt
	var t_amt_is_init = t_amt == _init_amt
	var amt_is_t_amt = amt == t_amt
	var amt_valid = false
	if _first_init:
		amt_valid = amt_is_init && t_amt_is_init && amt_is_t_amt
	else:
		if not amt_is_init or t_amt_is_init:
			_on_warning("lost tables in database validation.", false)
		amt_valid = amt_is_t_amt
	return amt_valid


func _on_warning(_message = "", _push_err = true):
	push_warning(_message)
	if _push_err:
		_on_init(null, _push_err)


func _on_db_not_of_class_type_warning(_push_err = false):
	_on_warning("database not of class type.", _push_err)


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
