"""
class_name SignalItemTypes

enum SignalType {
	NONE = 0,
	SELF_DEFERRED = 1,
	SELF_PERSIST = 2,
	SELF_ONESHOT = 3,
	SELF_REFERENCE_COUNTED = 4,
	NONSELF_DEFERRED = 5,
	NONSELF_PERSIST = 6,
	NONSELF_ONESHOT = 7,
	NONSELF_REFERENCE_COUNTED = 8
}

enum SignalFlagType {
	NONE = 0,
	CONNECT_DEFERRED = 1,
	CONNECT_PERSIST = 2,
	CONNECT_ONESHOT = 4,
	CONNECT_REFERENCE_COUNTED = 8
}

const VALID_SIGNAL_TYPES = [
	SignalType.SELF_DEFERRED,
	SignalType.SELF_PERSIST,
	SignalType.SELF_ONESHOT,
	SignalType.SELF_REFERENCE_COUNTED,
	SignalType.NONSELF_DEFERRED,
	SignalType.NONSELF_PERSIST,
	SignalType.NONSELF_ONESHOT,
	SignalType.NONSELF_REFERENCE_COUNTED,
]

const VALID_SIGNAL_FLAG_TYPES = [
	SignalFlagType.CONNECT_DEFERRED,
	SignalFlagType.CONNECT_PERSIST,
	SignalFlagType.CONNECT_ONESHOT,
	SignalFlagType.CONNECT_REFERENCE_COUNTED
]

export(SignalType) var signal_type_none setget , get_signal_type_none
export(SignalFlagType) var signal_flag_type_none setget , get_signal_flag_type_none


# setters, getters functions
func get_signal_type_none():
	return SignalType.NONE


func get_signal_flag_type_none():
	return SignalFlagType.NONE


static func invalid_signal_type():
	return SignalType.NONE


static func invalid_signal_flag_type():
	return SignalFlagType.NONE


static func get_valid_signal_types():
	return VALID_SIGNAL_TYPES


static func get_valid_signal_flag_types():
	return VALID_SIGNAL_FLAG_TYPES
"""