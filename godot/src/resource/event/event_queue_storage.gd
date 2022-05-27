tool
class_name EventQueueStorage extends RecyclableStorage

# properties
export(int) var queued_events_to_recycle_amt setget set_queued_events_to_recycle_amt, get_queued_events_to_recycle_amt
export(bool) var enable setget set_enable, get_enable
export(bool) var has_queued_events_to_recycle setget , get_has_queued_events_to_recycle

# fields
const _TYPE = "QueuedEvent"


# private inherited methods
func _init():
	var valid_instance = QueuedEvent.new()
	._init(_TYPE, valid_instance)


# setters, getters functions
func set_queued_events_to_recycle_amt(_amt = 0):
	if not .storage_enabled():
		_init()
	.on_to_recycle_amt(_amt)


func get_queued_events_to_recycle_amt():
	return .to_recycle_amt()


func set_enable(_enable = false):
	if _enable:
		_init()


func get_enable():
	return .storage_enabled()


func get_has_queued_events_to_recycle():
	return .has_to_recycle()
