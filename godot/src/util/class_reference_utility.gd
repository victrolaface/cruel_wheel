class_name ClassReferenceUtility


static func static_get_engine_class_list() -> PoolStringArray:
	return ClassDB.get_class_list()


static func static_get_script_class_list() -> PoolStringArray:
	return PoolStringArray(_get_script_map().keys())


static func static_get_class_list():
	var class_list := PoolStringArray()
	class_list.append_array(static_get_engine_class_list())
	class_list.append_array(static_get_script_class_list())
	return class_list


static func static_get_deep_class_list():
	var deep_type_map = _get_deep_type_map()
	var class_list := PoolStringArray(deep_type_map.keys())
	class_list.append_array(static_get_engine_class_list())
	return class_list


static func static_is_object_instance_of(p_object, p_type, p_map: Dictionary = {}):
	var is_instance_of = false
	var proc_is_instance_of = true
	while proc_is_instance_of:
		if not p_object or typeof(p_object) != TYPE_OBJECT:
			proc_is_instance_of = false
		var node := p_object as Node
		var map = p_map
		if map.empty():
			map = _get_script_map()
		if node and node.filename:
			is_instance_of = static_is_type(load(node.filename), p_type, map)
			proc_is_instance_of = false
		var script := p_object.get_script() as Script
		if script:
			is_instance_of = static_is_type(script, p_type, map)
			proc_is_instance_of = false
		is_instance_of = static_is_type(p_object.get_class(), p_type, map)
		proc_is_instance_of = false
	return is_instance_of


static func static_is_type(p_type, p_other, p_map: Dictionary = {}):
	var is_type = false
	var proc_is_type = true
	while proc_is_type:
		if not p_type:
			proc_is_type = false
		var map = _get_script_map() if p_map.empty() else p_map
		var other_class_exists = ClassDB.class_exists(p_other)
		var type_is_packed_scene = p_type is PackedScene
		var type_is_script = p_type is Script
		var other_is_packed_scene = p_other is PackedScene
		var other_is_script = p_other is Script
		match typeof(p_type):
			TYPE_STRING:
				is_type = (ClassDB.class_exists(p_type) && other_class_exists && ClassDB.is_parent_class(p_type, p_other))
				if is_type:
					proc_is_type = false
				var res_type := _convert_name_to_resource(p_type, map)
				is_type = res_type && static_is_type(res_type, p_other, map)
				proc_is_type = false
			TYPE_OBJECT:
				match typeof(p_other):
					TYPE_STRING:
						if other_class_exists:
							is_type = type_is_packed_scene && _scene_is_engine(p_type, p_other)
							if not is_type && type_is_script:
								is_type = _script_is_engine(p_type, p_other)
							proc_is_type = false
						var res_other := _convert_name_to_resource(p_other, map)
						if res_other:
							is_type = static_is_type(p_type, res_other, map)
							proc_is_type = false
					TYPE_OBJECT:
						if type_is_packed_scene:
							is_type = other_is_packed_scene && _scene_is_scene(p_type, p_other)
							if not is_type && other_is_script:
								is_type = _scene_is_script(p_type, p_other)
							proc_is_type = false
						elif type_is_script:
							is_type = other_is_packed_scene && _script_is_scene(p_type, p_other)
							if not is_type && other_is_script:
								is_type = _script_is_script(p_type, p_other)
		proc_is_type = false
	return is_type


static func from_name(p_name: String):
	var ref_from_name := _new()
	ref_from_name._init_from_name(p_name)
	return ref_from_name


static func from_path(p_path: String):
	var ref_from_path := _new()
	ref_from_path._init_from_path(p_path)
	return ref_from_path


static func from_object(p_object: Object):
	var ref_from_obj = _new()
	ref_from_obj._init_from_object(p_object)
	return ref_from_obj


static func from_type_dict(p_data: Dictionary):
	var ref_from_dict := _new()
	match p_data.type:
		"Engine":
			ref_from_dict._init_from_name(p_data.name)
		"Script", "PackedScene":
			ref_from_dict._init_from_path(p_data.path)
	return ref_from_dict


static func namify_path(p_path: String):
	var p := p_path.get_file().get_basename()
	while p != p.get_basename():
		p = p.get_basename()
	return p.capitalize().replace(" ", "")


static func _get_path_map(p_script_map: Dictionary):
	var path_map = {}
	for a_name in p_script_map:
		path_map[p_script_map[a_name].path] = a_name
	return path_map


static func _get_script_map():
	var script_classes: Array = (
		ProjectSettings.get_setting("_global_script_classes") as Array
		if ProjectSettings.has_setting("_global_script_classes")
		else []
	)
	var script_map := {}
	for a_class in script_classes:
		script_map[a_class["class"]] = a_class
	return script_map


static func _get_deep_type_map():
	var script_map = _get_script_map()
	var path_map = _get_path_map(script_map)
	var dirs = ["res://"]
	var first = true
	var data = {}
	var exts = {}
	var res_types = ["Script", "PackedScene"]
	for a_type in res_types:
		for a_ext in ResourceLoader.get_recognized_extensions_for_type(a_type):
			exts[a_ext] = a_type
	exts.erase("res")
	exts.erase("tres")
	while not dirs.empty():
		var dir = Directory.new()
		var dir_name = dirs.back()
		dirs.pop_back()
		if dir.open(dir_name) == OK:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name:
				if not dir_name == "res://":
					first = false
				if not file_name.begins_with("."):
					if dir.current_is_dir():
						dirs.push_back(dir.get_current_dir().plus_file(file_name))
					elif not data.has(file_name) and exts.has(file_name.get_extension()):
						var a_path = dir.get_current_dir() + ("/" if not first else "") + file_name
						var existing_name = path_map[a_path] if path_map.has(a_path) else ""
						var a_name = namify_path(file_name)
						a_name = a_name.replace("2d", "2D").replace("3d", "3D")
						if data.has(existing_name) and existing_name == a_name:
							file_name = dir.get_next()
							continue
						elif existing_name:
							a_name = existing_name
						data[a_name] = {"name": a_name, "path": a_path, "type": exts[file_name.get_extension()]}  # "Script" or "PackedScene"
				file_name = dir.get_next()
			dir.list_dir_end()
	return data


static func _get_script():
	return load("res://src/reference/class_reference.gd") as Script


static func _new() -> Reference:
	return (_get_script()).new() as Reference


static func _script_is_engine(p_script: Script, p_class: String):
	return ClassDB.is_parent_class(p_script.get_instance_base_type(), p_class)


static func _script_is_script(p_script: Script, p_other: Script):
	var script = p_script
	var is_script = false
	while script:
		if script == p_other:
			is_script = true
			script = false
		script = script.get_base_script()
	return is_script


static func _script_is_scene(p_script: Script, p_scene: PackedScene):
	var state := p_scene.get_state()
	var is_scene = false
	for prop_index in range(state.get_node_property_count(0)):
		if state.get_node_property_name(0, prop_index) == "script":
			var script := state.get_node_property_value(0, prop_index) as Script
			is_scene = _script_is_script(p_script, script)
	return is_scene


static func _scene_is_engine(p_scene: PackedScene, p_class: String):
	return ClassDB.is_parent_class(p_scene.get_state().get_node_type(0), p_class)


static func _scene_is_script(p_scene: PackedScene, p_script: Script):
	var is_script = false
	var proc_scene_is_script = true
	while proc_scene_is_script:
		if not p_scene or not p_script:
			proc_scene_is_script = false
		var script := _scene_get_root_script(p_scene)
		if not script:
			proc_scene_is_script = false
		is_script = _script_is_script(script, p_script)
		proc_scene_is_script = false
	return is_script


static func _scene_is_scene(p_scene: PackedScene, p_other: PackedScene):
	var is_scene = false
	is_scene = p_scene == p_other
	if not is_scene:
		var scene := p_scene
		while scene:
			var state := scene.get_state()
			var base = state.get_node_instance(0)
			is_scene = p_other == base
			if not is_scene:
				scene = base
			else:
				scene = null
	return is_scene


static func _convert_name_to_resource(p_name: String, p_map: Dictionary = {}) -> Resource:
	return (
		null
		if not p_name or ClassDB.class_exists(p_name) or p_map.empty() or not p_map.has(p_name)
		else load(p_map[p_name].path)
	)


static func _convert_name_to_variant(p_name: String, p_map: Dictionary = {}):
	var variant = null
	var variant_from_name = _convert_name_to_resource(p_name, p_map)
	if variant_from_name:
		variant = variant_from_name
	elif ClassDB.class_exists(p_name):
		variant = p_name
	return variant


static func _scene_get_root_script(p_scene: PackedScene) -> Script:
	var root_script = null
	var state := p_scene.get_state()
	while state:
		var prop_count := state.get_node_property_count(0)
		if prop_count:
			for i in range(prop_count):
				if state.get_node_property_name(0, i) == "script":
					var script := state.get_node_property_value(0, i) as Script
					root_script = script
					state = null
		var base := state.get_node_instance(0)
		if base:
			state = base.get_state()
		else:
			state = null
	return root_script


static func _scene_get_root_scene(p_scene: PackedScene) -> PackedScene:
	var root_scene = null
	if p_scene:
		var state := p_scene.get_state()
		root_scene = state.get_node_instance(0)
	return root_scene
