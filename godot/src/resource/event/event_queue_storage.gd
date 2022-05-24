class_name EventQueueStorage extends Resource

# properties
export(int) var queued_events_to_recycle_amt setget set_queued_events_to_recycle_amt, get_queued_events_to_recycle_amt
export(bool) var enabled setget set_enabled, get_enabled
export(bool) var initialized setget , get_initialized
export(bool) var has_queued_events_to_recycle setget , get_has_queued_events_to_recycle
export(String) var type setget , get_type

# fields
const _TYPE = "QueuedEvent"
var _data = {}


func _init(_initialized = false, _enabled = false, _to_recycle_amt = 0):
	_data = {
		"to_recycle": [],
		"to_recycle_amt": _to_recycle_amt,
		"state":
		{
			"initialized": _initialized,
			"enabled": _enabled,
		}
	}


# setters, getters functions
func set_queued_events_to_recycle_amt(_amt = 0):
	pass


func get_queued_events_to_recycle_amt():
	return _data.to_recycle_amt if _data.state.enabled else 0


func set_enabled(_enabled = false):
	if _enabled && not _data.state.enabled:
		var init_to_rec_amt = _data.to_recycle.size()
		var to_rec_amt = _data.to_recycle_amt
		if to_rec_amt > 0 && not init_to_rec_amt == to_rec_amt:
			var init_gt_rec_amt = init_to_rec_amt > to_rec_amt
			var init_lt_rec_amt = init_to_rec_amt < to_rec_amt
			var rem_amt = init_to_rec_amt - to_rec_amt if init_gt_rec_amt else 0
			var add_amt = to_rec_amt - init_to_rec_amt if init_lt_rec_amt else 0
			var idx = 0
			if init_gt_rec_amt:
				# rem at idx...idx
				pass
			elif init_lt_rec_amt:
				# add add_amt itms
				pass
		if not _data.state.initialized:
			_data.state.initialized = _enabled
		_data.state.enabled = _enabled
	pass


func get_enabled():
	return true if _data.state.enabled else false


func get_initialized():
	return _data.state.initialized if _data.state.enabled else false


func get_has_queued_events_to_recycle():
	return _data.to_recycle_amt if _data.state.enabled else false


func get_type():
	return _TYPE
