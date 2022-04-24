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
		"enabled": false,
	}
}


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
		if loaded == null or loaded.first_initialization:
			_data.db = ClassType.from_name(_data.table_type)
			var is_db = not _data.db == null && _data.db.get_class() == _data.table_type
			var classes = [_data.table_type, _data.base_class_names[0], _data.base_class_names[1]]
			var is_class = false
			for c in classes:
				is_class = _data.db.is_class(c)
				if not is_class:
					break
			if is_db && is_class:
				# can init db
				# validate
				pass


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


func _set_cached():
	_data.state.cached = _can_load_db() && _data.state.has_db


"""
var data = ResourceLoader.load(_PATH)
var db_valid = false
var class_names = ClassType.from_name(_BASE_CLASS_NAME).get_inheritors_list()
var class_names_amt = class_names.count()
var has_class_names = class_names_amt > 0
var first_init = data.first_initialization
if first_init:
    _on_init_name_mgr(self, _manager, first_init)
    if has_class_names:
        var db_init = SingletonTable.new(_CLASS_NAME, self, _manager)
        if db_init.enabled:
            var added = _on_add_init(class_names, _manager, db_init)
            db_init = added.db
            var items_is_cn_amt = _is_amt(db_init.items_amount, class_names_amt)
            var items_is_added_amt = _is_amt(db_init.items_amount, added.amount)
            db_valid = db_init.has_items && items_is_cn_amt && items_is_added_amt
            _on_db_valid(db_valid, db_init, true)

func _on_db_valid(_is_valid, _db, _is_first_init):
if _is_valid:
    _data.db = _db
    _data.state.has_db = true
    _data.state.cached = _data.state.has_name && _data.state.has_self_ref && _data.state.has_manager_ref
    _data.state.initialized = _data.state.cached
    _data.state.enabled = _data.state.initialized
    if _is_first_init:
        _data.state.first_init = not _data.state.initialized
    if _data.state.enabled:
        ResourceLoader.save(_PATH, self)
"""


# private helper methods
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

	"""        
        else:
			_on_init_name_mgr(self, _manager, first_init)
			if not data.db.enable(self, _manager):
				if not data.db.remove_disabled(_manager):
					push_error("unable to remove disabled items.")
			if not data.db.validate():  #
				if not data.db.remove_invalid():
					push_error("unable to remove invalid items.")
			if not has_class_names && data.db.items_amount > 0:
				if not data.db.remove_all():
					push_error("unable to remove all items")
			if has_class_names:
				if not data.db.has_keys(class_names):
					var idx_to_keep = []
					var idx = 0
					for cn in class_names:
						if not data.db.has_key(cn):
							idx_to_keep.append(idx)
						idx = idx + 1
					if idx_to_keep.count() > 0:
						var names_to_keep = []
						for i in idx_to_keep:
							names_to_keep.append(class_names[i])
						if names_to_keep.count() > 0:
							class_names = PoolStringArray(names_to_keep)
							class_names_amt = class_names.size()
							if class_names_amt > 0:
								var init_amt = data.db.items_amount
								var added = _on_add_init(class_names, _manager, data.db)
								data.db = added.db
								var init_classes_amt = init_amt + class_names_amt
								var init_added_amt = init_amt + added.amount
								var is_init_classes_amt = _is_amt(data.db.items_amount, init_classes_amt)
								var is_init_added_amt = _is_amt(data.db.items_amount, init_added_amt)
								db_valid = is_init_classes_amt && is_init_added_amt
								if not db_valid:
									push_error("unable to add items.")
				if data.db.has_keys_sans(class_names):
					var init_amt = data.db.items_amount
					var keys_sans = data.db.keys_sans(class_names)
					var keys_sans_amt = keys_sans.size()
					if keys_sans_amt > 0 && data.db.remove_keys(keys_sans):
						var rem_amt = init_amt - keys_sans_amt
						var is_init_rem_amt = _is_amt(data.db.items_amount, rem_amt)
						if db_valid:
							db_valid = db_valid && is_init_rem_amt
						else:
							db_valid = is_init_rem_amt
						if not db_valid:
							push_error("unable to remove invalid items.")
				_on_db_valid(db_valid, data.db, false)


# public methods
func disable():
	if _data.state.enabled:
		if _data.db.disable():
			_data.manager_ref = null
			_data.self_ref = null
			_data.state.first_init = false
			_data.state.has_manager_ref = false
			_data.state.has_self_ref = false
			_data.state.cached = false
			_data.state.initialized = false
			_data.state.enabled = false
			if not ResourceSaver.save(_PATH, self):
				push_warning("unable to save database.")
		else:
			push_warning("unable to disable to disable database.")
	return not _data.state.enabled


# private helper methods
func _on_init_name_mgr(_self_ref, _mgr, _is_first_init):
	_data.name = _CLASS_NAME
	_data.state.has_name = StringUtility.is_valid(_data.name)
	_data.self_ref = self
	_data.state.has_self_ref = not _data.self_ref == null
	_data.manager_ref = _mgr
	_data.state.has_manager_ref = not _data.manager_ref == null
	if _is_first_init:
		_data.state.first_init = false


func _is_amt(_amt1, _amt2):
	return _amt1 == _amt2


func _on_add_init(_class_names, _manager, _db):
	var added_amt = 0
	for cn in _class_names:
		var s = ClassType.from_name(cn)
		s._init()
		if s.init_from_manager(_manager):
			if s.enabled && _db.add(s.name, s):
				added_amt = added_amt + 1
	var added = {"amount": added_amt, "db": _db}
	return added





# setters, getters functions
func get_enabled():
	return _data.state.enabled


func get_first_initialization():
	return _data.state.first_init
        """
