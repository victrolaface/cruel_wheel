tool
class_name SignalManager extends ResourceCollection

#export(Array, Resource) var signals

var db = {}


func _init():
	#set_base_type(SignalItem)
	#set_type_readonly(true)
	db = {"self": {"oneshot": [], "deferred": []}, "nonself": {"oneshot": [], "deferred": []}}


func _add(_c, _o_f, _n, _o_t, _m, _a, _ct, _st):
	var added = false
	if SignalItem.is_valid(_c, _o_f, _n, _o_t, _m, _a, _ct, _st, _o_f.resource_local_to_scene):
		var s = SignalItem.new(_c, _o_f, _n, _o_t, _m, _a, _ct, _st, _o_f.resource_local_to_scene)
		added = true
	return added
