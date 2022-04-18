#class_name PhysicsSmoothCore extends Reference
"""
# fields
const FI_NONE: int = 0
const FI_TRANSLATION: int = 1
const FI_ORIENTATION: int = 2
const FI_SCALE: int = 4
const FI_ALL: int = FI_TRANSLATION | FI_ORIENTATION | FI_SCALE




# Base class to hold interpolation data
class InterpData:
	var had_physics: bool
	
	func cycle(is_in_physics: bool) -> void:
		if (had_physics):
			_cycle()
		
		had_physics = is_in_physics
	
	func _init() -> void:
		had_physics = false
	
	func _cycle() -> void:
		pass
	
	func snap_to_target() -> void:
		pass


class IData2D extends InterpData:
	var from: Transform2D
	var to: Transform2D
	var target: Node2D
	
	func calculate(mask: int) -> Transform2D:
		var alpha: float = Engine.get_physics_interpolation_fraction()
		var retval: Transform2D
		match mask:
			FI_NONE:
				retval = to
			FI_ALL:
				retval = from.interpolate_with(to, alpha)
			_:
				# It is a lot easier to first interpolate everything and selectively assign
				var interpolated: Transform2D = from.interpolate_with(to, alpha)
				if (mask & FI_TRANSLATION):
					# Translation is enabled, so take the interpolated value
					retval.origin = interpolated.origin
				else:
					retval.origin = to.origin
				
				# OK, rotation and scale are a bit more complicated to be individually done.
				var scale: Vector2 = interpolated.get_scale() if (mask & FI_SCALE) else to.get_scale()
				var rot: float = interpolated.get_rotation() if (mask & FI_ORIENTATION) else to.get_rotation()
				var cr: float = cos(rot)
				var sr: float = sin(rot)
				
				retval.x = Vector2(cr, sr) * scale.x
				retval.y = Vector2(-sr, cr) * scale.y
		
		
		return retval
	
	func setft(f: Transform2D, t: Transform2D) -> void:
		from = f
		to = t
	
	func snap_to_target() -> void:
		if (target):
			setft(target.global_transform, target.global_transform)
	
	func change_target(t: Node2D) -> void:
		if (t):
			target = t
			setft(t.global_transform, t.global_transform)
	
	func _init(t: Node2D).() -> void:
		target = t
		snap_to_target()
	
	
	func _cycle() -> void:
		from = to
		to = target.global_transform



class IData3D extends InterpData:
	var from: Transform
	var to: Transform
	var target: Spatial
	
	
	func calculate(mask: int) -> Transform:
		var alpha: float = Engine.get_physics_interpolation_fraction()
		var retval: Transform
		match mask:
			FI_NONE:
				retval = to
			FI_ALL:
				retval = from.interpolate_with(to, alpha)
			_:
				# Like the 2D case, it's a bit easier to first interpolate everything and selectivelly take
				# from it or the target
				var interpolated: Transform = from.interpolate_with(to, alpha)
				if (mask & FI_TRANSLATION):
					# Translation is enabled, so take the interpolated value
					retval.origin = interpolated.origin
				else:
					retval.origin = to.origin
				
				var scale: Vector3 = interpolated.basis.get_scale() if (mask & FI_SCALE) else to.basis.get_scale()
				var euler: Vector3 = interpolated.basis.get_euler() if (mask & FI_ORIENTATION) else to.basis.get_euler()
				
				retval.basis = Basis(euler).scaled(scale)
		
		return retval
	
	
	func setft(f: Transform , t: Transform) -> void:
		from = f
		to = t
	
	func snap_to_target() -> void:
		if (target):
			setft(target.global_transform, target.global_transform)
	
	func change_target(t: Spatial) -> void:
		if (t):
			target = t
			setft(t.global_transform, t.global_transform)
	
	
	func _init(t: Spatial).() -> void:
		target = t
		snap_to_target()
	
	func _cycle() -> void:
		from = to
		to = target.global_transform

static func set_bits(fullval: int, mask: int, enable: bool) -> int:
	if (enable):
		return fullval | mask
	else:
		return fullval & ~mask

static func is_enabled(fullval: int, mask: int) -> bool:
	return (fullval & mask) == mask
"""