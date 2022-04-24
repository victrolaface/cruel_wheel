tool
class_name SingletonDatabase extends Resource

# properties
export(bool) var enabled setget , get_enabled
export(bool) var first_initialization setget , get_first_initialization

# fields
var _data = {
	"name": "",
	"manager_ref": null,
	"self_ref": null,
	"db": null,
	"state":
	{
		"first_init": true,
		"has_name": false,
		"has_manager_ref": false,
		"has_self_ref": false,
		"has_db": false,
		"cached": false,
		"initialized": false,
		"enabled": false,
	}
}

const _BASE_CLASS_NAME = "Singleton"
const _CLASS_NAME = "SingletonDatabase"
const _PATH = "res://data/singleton_db.tres"


# public inherited methods
func is_class(_class: String):
	return _class == _CLASS_NAME or _class == _BASE_CLASS_NAME


func get_class():
	return _CLASS_NAME


# private inherited methods
func _init(_manager = null):
	if _manager.initialized:
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


# setters, getters functions
func get_enabled():
	return _data.state.enabled


func get_first_initialization():
	return _data.state.first_init
