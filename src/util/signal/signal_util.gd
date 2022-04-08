tool
extends Resource
class_name SignalUtility

var data = preload("signal_meta_set.gd")

func _init():
    data = {
        "self": null,
        "to": null,
        "oneshot": [{
            "obj_from": null,
            "connected": false,
            "signal": "",
            "obj_to": null,
            "method": "",
            "args": [],
            "flags": CONNECT_ONESHOT
        }],
        "deferred": [{
            "obj_from": null,
            "connected": false,
            "signal": "",
            "obj_to": null,
            "method": "",
            "args": [],
            "flags": CONNECT_DEFERRED
        }],
    }

#class_name SignalMeta

static func connected(
	_obj_from: Object,
	_connected: bool,
	_signal: String,
	_obj_to: Object,
	_method: String,
	_args = [],
	_flags = Object.CONNECT_DEFERRED
):
	if not _connected && not _obj_from.is_connected(_signal, _obj_to, _method):
		_connected = _obj_from.connect(_signal, _obj_to, _method, _args, _flags)
	return _connected

