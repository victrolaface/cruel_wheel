tool
extends Resource
class_name SignalMetaSet

export(Dictionary) var meta


func _init():
	meta = {"oneshot": [], "deferred": []}


func add(_item: SignalMeta):
	if _item == null || _item.get_class() != "SignalMeta":
		return
	if _item.flags == CONNECT_ONESHOT:
		meta.oneshot.add(_item)
	elif _item.flags == CONNECT_DEFERRED:
		meta.deferred.add(_item)


func add_set(_items: Array):
	for i in _items:
		if i.get_class() != "SignalMeta":
			continue
		var dup = false
		var met = []
		var is_oneshot = i.flags == CONNECT_ONESHOT
		var is_deferred = i.flags == CONNECT_DEFERRED
		if is_oneshot:
			met = met.oneshot
		elif is_deferred:
			met = met.deferred
		else:
			continue
		for m in met:
			if m.signal == i.signal:
				dup = true
				break
		if dup:
			continue
		if is_oneshot:
			meta.oneshot.add(i)
		elif is_deferred:
			meta.deferred.add(i)
		else:
			continue
