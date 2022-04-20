tool
class_name ClassReference extends Reference

enum Source {
	NONE,
	ENGINE,
	SCRIPT,
	ANONYMOUS,
}

export(String) var name setget set_name, get_name
export(String, FILE) var path setget set_path, get_path
export(Resource) var resource setget set_resource, get_resource

var script_map_dirty: bool setget set_script_map_dirty, get_script_map_dirty

var _data = {
	"name": "",
	"path": "",
	"resource": null,
	"source": Source.NONE,
	"script_map": {},
	"path_map": {},
	"deep_type_map": {},
	"deep_path_map": {},
	"state": {"script_map_dirty": true, "is_filesystem_connected": false}
}


func _init(p_input = null, p_generate_deep_map = true, p_duplicate_maps = true):
	if p_generate_deep_map:
		_fetch_deep_type_map()
	match typeof(p_input):
		TYPE_OBJECT:
			if p_input is (get_script() as Script):
				_data.name = p_input.name
				if p_duplicate_maps:
					_data.script_map = p_input._script_map.duplicate()
					_data.path_map = p_input._path_map.duplicate()
					_data.deep_type_map = p_input._deep_type_map.duplicate()
					_data.deep_path_map = p_input._deep_path_map.duplicate()
				else:
					_data.script_map = p_input._script_map
					_data.path_map = p_input._path_map
					_data.deep_type_map = p_input._deep_type_map
					_data.deep_path_map = p_input._deep_path_map
			else:
				_init_from_object(p_input)
				_connect_script_updates()
		TYPE_STRING:
			if ResourceLoader.exists(p_input):
				_init_from_path(p_input)
			else:
				_init_from_name(p_input)
			_connect_script_updates()
	return


func to_string():
	var _str = ""
	if _data.name:
		_str = _data.name
	if _data.resource:
		var named_path = ClassReferenceUtility.namify_path(_data.resource.resource_path)
		if _data.resource is PackedScene:
			named_path += "Scn"
		_str = named_path
	return _str


func get_script_classes():
	_fetch_script_map()
	return _data.script_map


func get_path_map():
	_fetch_script_map()
	return _data.path_map


func get_deep_type_map():
	_fetch_deep_type_map()
	return _data.deep_type_map


func get_deep_path_map():
	_fetch_deep_type_map()
	return _data.deep_path_map


func refresh_script_classes():
	_data.script_map = ClassReferenceUtility._get_script_map()
	_build_path_map()


func refresh_deep_type_map():
	_data.deep_type_map = ClassReferenceUtility._get_deep_type_map()
	_build_deep_path_map()


func is_type(p_other):
	var is_type = false
	var is_type_other_name = false
	var is_script = p_other.get_script() == get_script()
	var is_type_object = typeof(p_other) == TYPE_OBJECT
	match _data.source:
		Source.NONE:
			is_type = false
		Source.ENGINE:
			is_type_other_name = is_type_object and is_script
			if not is_type_other_name:
				is_type = _is_type(_data.name, p_other)
	if is_type_other_name:
		is_type = _is_type(_data.name, p_other.name)
	else:
		if is_type_object:
			match p_other.get_class():
				"Script", "PackedScene":
					pass
				_:
					is_type_other_name = is_script
					if not is_type_other_name:
						var other = ClassReferenceUtility.from_object(p_other)
						is_type = other.resource && _is_type(_data.resource, other.resource)
		else:
			is_type = _is_type(_data.resource, p_other)
	if is_type_other_name:
		is_type = _is_type(_data.name, p_other.name)
	return is_type


func _is_type(_name, _other):
	return ClassReferenceUtility.static_is_type(_name, _other, _get_map())


func instance():
	var instance = null
	if _data.source == Source.ENGINE:
		instance = ClassDB.instance(_data.name)
	elif _data.resource:
		if _data.resource is Script:
			instance = _data.resource.new()
		elif _data.resource is PackedScene:
			instance = _data.resource.instance()
	return instance


func get_engine_class():
	var engine_class = ""
	if Source.ENGINE == _data.source:
		engine_class = _data.name
	elif _data.resource:
		if _data.resource is Script:
			engine_class = (_data.resource as Script).get_instance_base_type()
		elif _data.resource is PackedScene:
			var state := (_data.resource as PackedScene).get_state()
			engine_class = state.get_node_type(0)
	return engine_class


func get_script_class():
	var script_class = ""
	var script_null = false
	match _data.source:
		Source.ENGINE:
			script_null = true
	if not script_null:
		var script = null
		if _data.resource:
			var scene := _data.resource as PackedScene
			if scene:
				script = ClassReferenceUtility._scene_get_root_script(scene)
			elif _data.resource is Script:
				script = _data.resource as Script
		_fetch_script_map()
		var script_class_is_resource = false
		var resource_from_path_map = null
		while script:
			if _data.path_map.has(script.resource_path):
				resource_from_path_map = _data.path_map[script.resource_path]
				script_class_is_resource = true
				script = false
			script = script.get_base_script()
		if script_class_is_resource:
			script_class = resource_from_path_map
	return script_class


func get_type_class():
	var type_class = get_script_class()
	if not StringUtility.is_valid(type_class):
		type_class = get_engine_class()
	return type_class


func class_exists():
	return not _data.source == Source.NONE


func path_exists():
	return ResourceLoader.exists(_data.path)


func is_valid():
	return class_exists() or path_exists()


func is_non_class_res():
	return path_exists() and not class_exists()


func as_script():
	return _data.resource as Script


func as_scene():
	return _data.resource as PackedScene


func get_engine_parent():  # -> Reference:
	var engine_parent := ClassReferenceUtility._new()
	if _data.source == Source.SCRIPT:
		engine_parent.name = get_engine_class()
	elif _data.source == Source.ENGINE:
		engine_parent.name = ClassDB.get_parent_class(_data.name)
	return engine_parent


func get_script_parent():  # -> Reference:
	var script_parent := ClassReferenceUtility._new()
	if _data.source == Source.ENGINE:
		script_parent.name = ""
	elif _data.resource:
		var scene := _data.resource as PackedScene
		if scene:
			var script := ClassReferenceUtility._scene_get_root_script(scene)
			script_parent._init_from_object(script)
		else:
			var script := _data.resource as Script
			if script:
				script_parent._init_from_object(script.get_base_script())
			else:
				script_parent.path("")
	return script_parent


func get_scene_parent():  # -> Reference:
	var scene_parent := ClassReferenceUtility._new()
	var on_engine_or_script = false
	match _data.source:
		Source.ENGINE, Source.SCRIPT:
			on_engine_or_script = true
	if not on_engine_or_script:
		var scene := _data.resource as PackedScene
		scene = ClassReferenceUtility._scene_get_root_scene(scene)
		scene_parent.resource = scene
	return scene_parent


func get_type_parent():
	var parent_type = get_scene_parent()
	var validating = true
	while validating:
		var valid = parent_type.is_valid()
		validating = not valid
		parent_type = get_script_parent()
		valid = parent_type.is_valid()
		validating = not valid
		parent_type = get_engine_parent()
		validating = false
	return parent_type


func become_parent():
	var parent = false
	var proc_become_parent = true
	while proc_become_parent:
		if not _data.resource && not _data.name:
			parent = true
			proc_become_parent = not parent
		_data.name = ClassDB.get_parent_class(_data.name)
		parent = ClassDB.class_exists(_data.name)
		proc_become_parent = not parent
		var scene := _data.resource as PackedScene
		var base := ClassReferenceUtility._scene_get_root_scene(scene)
		parent = scene && base
		if parent:
			_data.resource = base
			proc_become_parent = not parent
		else:
			var script := ClassReferenceUtility._scene_get_root_script(scene)
			parent = script
			if parent:
				_data.resource = script
		proc_become_parent = false
	return parent


func get_type_script():  # -> Script:
	var scene := _data.resource as PackedScene
	var script = null
	if scene:
		script = ClassReferenceUtility._scene_get_root_script(scene)
	if not script:
		script = _data.resource as Script
	return script


func can_instance():  # -> bool:
	var instance = false
	if _data.source == Source.ENGINE:
		instance = ClassDB.can_instance(_data.name)
	if not instance:
		var script = get_type_script()
		if script:
			instance = script.can_instance()
	return instance  #false


func is_object_instance_of(p_object):  # -> bool:
	var ct = ClassReferenceUtility.from_object(p_object)
	return is_type(ct)


func get_inheritors_list():
	var class_list = get_class_list()
	return _on_inheritors_list(class_list)


func get_deep_inheritors_list():
	_fetch_deep_type_map()
	var class_list := PoolStringArray(_data.deep_type_map.keys())
	return _on_inheritors_list(class_list)


func _on_inheritors_list(_list):
	var list := PoolStringArray()
	for i in _list:
		if i != _data.name and ClassReferenceUtility.static_is_type(i, _data.name, _get_map()):
			list.append(i)
	return list


func get_engine_class_list():
	return ClassDB.get_class_list()


func get_script_class_list():
	_fetch_script_map()
	return PoolStringArray(_data.script_map.keys())


func get_class_list():
	var class_list := PoolStringArray()
	class_list.append_array(get_engine_class_list())
	class_list.append_array(get_script_class_list())
	return class_list


func get_deep_class_list():
	_fetch_deep_type_map()
	var class_list := PoolStringArray(_data.deep_type_map.keys())
	class_list.append_array(PoolStringArray(get_engine_class_list()))
	return class_list


func _get_map():
	var map := {}
	if not _data.deep_type_map.empty():
		map = _data.deep_type_map
	if map.empty():
		_fetch_script_map()
		map = _data.script_map
	return map


func _init_from_name(p_name: String):
	var dirty = true
	_data.name = p_name
	while dirty:
		if ClassDB.class_exists(p_name):
			_data.path = ""
			_data.resource = null
			_data.source = Source.ENGINE
			dirty = false
		_fetch_script_map()
		if _data.deep_type_map.has(p_name):
			_data.path = _data.deep_type_map[p_name].path
			_data.resource = load(path)
			_data.source = Source.ANONYMOUS
			if _data.script_map.has(p_name):
				_data.source = Source.SCRIPT
			dirty = false
		if _data.script_map.has(p_name):
			_data.path = _data.script_map[p_name].path
			_data.resource = load(_data.path)
			_data.source = Source.SCRIPT
			dirty = false
		_data.path = ""
		_data.resource = null
		_data.source = Source.NONE
		_connect_script_updates()
		dirty = false


func _init_from_path(p_path: String) -> void:
	_data.path = p_path
	_data.resource = load(_data.path) if ResourceLoader.exists(_data.path) else null
	_fetch_script_map()
	var init = true
	while init:
		if not _data.deep_path_map.empty() and _data.deep_path_map.has(p_path):
			_data.name = _data.deep_path_map[p_path]
			_data.source = Source.ANONYMOUS
			if _data.script_map.has(_data.name):
				_data.source = Source.SCRIPT
			init = false
		if _data.path_map.has(p_path):
			_data.name = _data.path_map[p_path]
			_data.source = Source.SCRIPT
			init = false
		_data.name = ""
		_data.source = Source.NONE
		_connect_script_updates()
		init = false


func _init_from_object(p_object: Object):
	var init = false
	if not p_object:
		_data.name = ""
		_data.path = ""
		_data.resource = null
		_data.source = Source.NONE
		init = true
	var n := p_object as Node
	if not init and n and n.filename:
		_init_from_path(n.filename)
		init = true
	var s := (p_object.get_script() as Script) if p_object else null
	if not init and s:
		if not s.resource_path:
			_data.resource = s
			_data.path = ""
			_data.name = ""
			_data.source = Source.ANONYMOUS
		else:
			_init_from_path(s.resource_path)
		init = true
	if not init and (p_object is PackedScene or p_object is Script):
		_init_from_path((p_object as Resource).resource_path)
		init = true
	if not init and not _data.path and not _data.name:
		_init_from_name(p_object.get_class())
		init = true
	_connect_script_updates()


func _connect_script_updates():
	if Engine.editor_hint and not _data.state.is_filesystem_connected:
		var ep: EditorPlugin = EditorPlugin.new()
		var fs: EditorFileSystem = ep.get_editor_interface().get_resource_filesystem()
		var fs_connected = fs.is_connected("filesystem_changed", self, "set")
		if not fs_connected:
			fs_connected = fs.connect("filesystem_changed", self, "set_script_map_dirty", [true])
		ep.free()
		_data.state.is_filesystem_connected = fs_connected


func _fetch_script_map():
	if _data.state.script_map_dirty:
		_data.script_map = ClassReferenceUtility._get_script_map()
		_build_path_map()
		_data.state.script_map_dirty = false


func _build_path_map():
	_data.path_map = ClassReferenceUtility._get_path_map(_data.script_map)


func _fetch_deep_type_map():
	if _data.deep_type_map.empty():
		_data.deep_type_map = ClassReferenceUtility._get_deep_type_map()
		_build_deep_path_map()


func _build_deep_path_map():
	_data.deep_path_map = _get_deep_path_map(_data.deep_type_map)


func _get_deep_path_map(p_deep_type_map: Dictionary):
	var deep_path_map = {}
	for a_name in p_deep_type_map:
		deep_path_map[p_deep_type_map[a_name].path] = a_name
	return deep_path_map


func set_name(p_value: String):
	_init_from_name(p_value)


func get_name():
	return _data.name


func set_path(p_value: String):
	_init_from_path(p_value)


func get_path():
	return _data.path


func set_resource(p_value: Resource):
	if not p_value:
		_data.name = ""
	_init_from_object(p_value)


func get_resource():
	return _data.resource


func set_script_map_dirty(_script_map_dirty: bool):
	_data.state.script_map_dirty = _script_map_dirty


func get_script_map_dirty():
	return _data.state.script_map_dirty
