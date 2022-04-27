class_name ClassNameUtility


# public methods
static func is_class_name(_class_name: String, _base_class_names: PoolStringArray):
	var has_class_name = false
	for n in _base_class_names:
		has_class_name = n == _class_name
		if has_class_name:
			break
	return has_class_name


static func init_base_class_names(_class_names: Array, _base_class_names: PoolStringArray):
	var class_names_amt = _class_names.size()
	if class_names_amt > 0 && _base_class_names.size() > 0:
		var class_names_sans_base = PoolStringArray()
		class_names_sans_base.clear()
		var class_names_sans_base_amt = 0
		var idx = 0
		for n in _class_names:
			if not is_class_name(n, _base_class_names):
				class_names_sans_base_amt = class_names_sans_base_amt + 1
				class_names_sans_base.resize(class_names_sans_base_amt)
				class_names_sans_base.set(idx, n)
				idx = idx + 1
		if class_names_sans_base_amt > 0:
			var base_class_amt = 0
			for n in _base_class_names:
				base_class_amt = base_class_amt + 1
			var base_class_names = PoolStringArray()
			base_class_names.clear()
			base_class_names.resize(class_names_sans_base + base_class_amt)
			idx = 0
			for n in class_names_sans_base:
				base_class_names.set(idx, n)
				idx = idx + 1
			for n in _base_class_names:
				base_class_names.set(idx, n)
			_base_class_names = base_class_names
	return _base_class_names
