tool
class_name PhysicsSmoothInterpolation extends Reference


static func bits(_full_val: int, _mask: int, _enable: bool):
	return (_full_val | _mask) if _enable else (_full_val & ~_mask)


static func is_enabled(_full_val: int, _mask: int):
	return (_full_val & _mask) == _mask
