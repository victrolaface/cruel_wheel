tool
class_name RigidBody2DWrapper extends Resource

"""
changed()
body_entered ( Node body )
body_exited ( Node body )
body_shape_entered ( RID body_rid, Node body, int body_shape_index, int local_shape_index )
body_shape_exited ( RID body_rid, Node body, int body_shape_index, int local_shape_index )
sleeping_state_changed ( )
"""

signal rigid_body_changed
signal received_rigid_body
signal received_collider
signal received_physics_override
signal body_entered(body)
signal body_exited(body)
signal body_shape_entered(body_rid, body, body_shape_index, local_shape_index)
signal body_shape_exited(body_rid, body, body_shape_index, local_shape_index)
signal sleeping_state_changed

export(Resource) var rigid_body setget set_rigid_body, get_rigid_body
export(Resource) var physics_material_override setget set_physics_material_override, get_physics_material_override
export(Resource) var collider setget set_collider, get_collider
export(bool) var has_rigid_body setget set_has_rigid_body, get_has_rigid_body
export(bool) var has_physics_material_override setget set_has_physics_material_override, get_has_physics_material_override
export(bool) var has_collider setget set_has_collider, get_has_collider
export(bool) var can_sleep setget set_can_sleep, get_can_sleep
export(bool) var contact_monitor setget set_contact_monitor, get_contact_monitor
export(bool) var sleeping setget set_sleeping, get_sleeping
export(bool) var custom_integrator setget set_custom_integrator, get_custom_integrator
export(int) var continuous_cd setget set_continuous_cd, get_continuous_cd
export(bool) var rough setget set_rough, get_rough
export(bool) var absorbent setget set_absorbent, get_absorbent
export(int) var mode setget set_mode, get_mode
export(int) var contacts_reported setget set_contacts_reported, get_contacts_reported
export(float) var angular_damp setget set_angular_damp, get_angular_damp
export(float) var angular_velocity setget set_angular_velocity, get_angular_velocity
export(float) var applied_torque setget set_applied_torque, get_applied_torque
export(float) var gravity_scale setget set_gravity_scale, get_gravity_scale
export(float) var inertia setget set_inertia, get_inertia
export(float) var linear_damp setget set_linear_damp, get_linear_damp
export(float) var mass setget set_mass, get_mass
export(float) var weight setget set_weight, get_weight
export(float) var friction setget set_friction, get_friction
export(float) var bounce setget set_bounce, get_bounce
export(Vector2) var applied_force setget set_applied_force, get_applied_force
export(Vector2) var linear_velocity setget set_linear_velocity, get_linear_velocity

const COL_CLASS_NAME = "CollisionShape2D"

var rb: RigidBody2D
var col: CollisionShape2D
var has_rb = false
var has_phys_mat = false
var has_col = false
var is_init = false
var signal_mgr = preload("res://src/signal/signal_manager.gd")


func _init():
	rb = null
	col = null
	has_rb = false
	has_phys_mat = false
	has_col = false
	is_init = false


# setters, getters
func set_rigid_body(_obj: Object):
	if _obj != null && not has_rb && _obj.is_class("RigidBody2D"):
		rb = _obj
		has_rb = true
		if not has_phys_mat && rb.physics_material_override != null:
			_validate_phys_mat(rb.physics_material_override, false, 0.0, 1.0, false)
		if not has_col && rb.has_node(COL_CLASS_NAME):
			col = rb.get_node(COL_CLASS_NAME)
			has_col = col != null


func get_rigid_body():
	if has_rigid_body:
		return rb


func set_physics_material_override(_p: PhysicsMaterial):
	if has_rigid_body:
		if _p != null && has_phys_mat:
			_validate_phys_mat(_p, _p.absorbent, _p.bounce, _p.friction, _p.rough)
		else:
			_validate_phys_mat(_p, false, 0.0, 1.0, false)


func get_physics_material_override():
	if not has_phys_mat:
		return
	return rb.physics_material_override


func set_collider(_col: CollisionShape2D):
	pass


func get_collider():
	if not has_col:
		return
	return col


func set_has_rigid_body(_has_rb: bool):
	pass


func get_has_rigid_body():
	return has_rb


func set_has_physics_material_override(_has: bool):
	pass


func get_has_physics_material_override():
	return has_phys_mat


func get_has_collider():
	return has_col


func set_has_collider(_has: bool):
	pass


func set_can_sleep(_can: bool):
	if not has_rb:
		return
	rb.can_sleep = _can


func get_can_sleep():
	if not has_rb:
		return
	return rb.can_sleep


func set_contact_monitor(_contact_monitor: bool):
	if not has_rb:
		return
	rb.contact_monitor = _contact_monitor


func get_contact_monitor():
	if not has_rb:
		return
	return rb.contact_monitor


func set_sleeping(_sleeping: bool):
	if not has_rb:
		return
	if _sleeping != rb.sleeping:
		rb.emit_signal("sleeping_state_changed")
	rb.sleeping = _sleeping


func get_sleeping():
	if not has_rb:
		return
	return rb.sleeping


func set_custom_integrator(_custom_integrator: bool):
	if not has_rb:
		return
	rb.custom_integrator = _custom_integrator


func get_custom_integrator():
	if not has_rb:
		return
	return rb.custom_integrator


func set_continuous_cd(_mode: int):
	if not has_rb:
		return
	rb.continous_cd = _mode


func get_continuous_cd():
	if not has_rb:
		return
	return rb.continuous_cd


func set_rough(_rough: bool):
	if not has_rb:
		return
	rb.physics_material_override.rough = _rough


func get_rough():
	if not has_rb:
		return
	return rb.physics_material_override.rough


func set_absorbent(_absorbent: bool):
	if not has_rb:
		return
	rb.physics_material_override.absorbent = _absorbent


func get_absorbent():
	if not has_rb:
		return
	return rb.physics_material_override.absorbent


func set_mode(_mode: int):
	if not has_rb:
		return
	rb.mode = _mode


func get_mode():
	if not has_rb:
		return
	return rb.mode


func set_contacts_reported(_contacts_reported: int):
	if not has_rb:
		return
	rb.contacts_reported = _contacts_reported


func get_contacts_reported():
	if not has_rb:
		return
	return rb.contacts_reported


func set_angular_damp(_angular_damp: float):
	if not has_rb:
		return
	rb.angular_damp = _angular_damp


func get_angular_damp():
	if not has_rb:
		return
	return rb.angular_damp


func set_angular_velocity(_angular_velocity: float):
	if not has_rb:
		return
	rb.angular_velocity = _angular_velocity


func get_angular_velocity():
	if not has_rb:
		return
	return rb.angular_velocity


func set_applied_torque(_applied_torque: float):
	if not has_rb:
		return
	rb.applied_torque = _applied_torque


func get_applied_torque():
	if not has_rb:
		return
	return rb.applied_torque


func set_gravity_scale(_gravity_scale: float):
	if not has_rb:
		return
	rb.gravity_scale = _gravity_scale


func get_gravity_scale():
	if not has_rb:
		return
	return rb.gravity_scale


func set_inertia(_inertia: float):
	if not has_rb:
		return
	rb.inertia = _inertia


func get_inertia():
	if not has_rb:
		return
	return rb.inertia


func set_linear_damp(_linear_damp: float):
	if not has_rb:
		return
	rb.linear_damp = _linear_damp


func get_linear_damp():
	if not has_rb:
		return
	return rb.linear_damp


func set_mass(_mass: float):
	if not has_rb:
		return
	rb.mass = _mass


func get_mass():
	if not has_rb:
		return
	return rb.mass


func set_weight(_weight: float):
	if not has_rb:
		return
	rb.weight = _weight


func get_weight():
	if not has_rb:
		return
	return rb.weight


func set_friction(_friction: float):
	if not has_rb:
		return
	rb.physics_material_override.friction = _friction


func get_friction():
	if not has_rb:
		return
	return rb.physics_material_override.friction


func set_bounce(_bounce: float):
	if not has_rb:
		return
	rb.physics_material_override.bounce = _bounce


func get_bounce():
	if not has_rb:
		return
	return rb.physics_material_override.bounce


func set_applied_force(_applied_force: Vector2):
	if not has_rb:
		return
	rb.applied_force = _applied_force


func get_applied_force():
	if not has_rb:
		return
	return rb.applied_force


func set_linear_velocity(_linear_velocity: Vector2):
	if not has_rb:
		return
	rb.linear_velocity = _linear_velocity


func get_linear_velocity():
	if not has_rb:
		return
	return rb.linear_velocity


# getters, setters helper functions
func _validate_phys_mat(_p: PhysicsMaterial, _abs: bool, _bnc: float, _fr: float, _rgh: bool):
	var amt = 0
	amt = _valid_phys_mat_prop(amt, rb.physics_material_override.absorent != _abs)
	amt = _valid_phys_mat_prop(amt, rb.physics_material_override.bounce != _bnc)
	amt = _valid_phys_mat_prop(amt, rb.physics_material_override.friction != _fr)
	amt = _valid_phys_mat_prop(amt, rb.physics_material_override.rough != _rgh)
	has_phys_mat = amt == 4
	if has_phys_mat:
		rb.physics_material_override = _p
	return has_phys_mat


func _valid_phys_mat_prop(_amt: int, _valid: bool):
	if _valid:
		_amt = _amt + 1
	return _amt


# adapted methods
func initegrate_forces(_state: Physics2DDirectBodyState):
	if not has_rb:
		return
	rb.integrate_forces(_state)


func add_central_force(_force: Vector2):
	if not has_rb:
		return
	rb.add_central_force(_force)


func add_force(_offset: Vector2, _force: Vector2):
	if not has_rb:
		return
	rb.add_force(_offset, _force)


func add_torque(_torque: float):
	if not has_rb:
		return
	rb.add_torque(_torque)


func apply_central_impulse(_impulse: Vector2):
	if not has_rb:
		return
	rb.apply_central_impulse(_impulse)


func apply_impulse(_offset: Vector2, _impulse: Vector2):
	if not has_rb:
		return
	rb.apply_impulse(_offset, _impulse)


func apply_torque_impulse(_torque: float):
	if not has_rb:
		return
	rb.apply_torque_impulse(_torque)


func get_colliding_bodies():
	if not has_rb:
		return
	return rb.get_colliding_bodies()


func set_axis_velocity(_axis_velocity: Vector2):
	if not has_rb:
		return
	rb.set_axis_velocity(_axis_velocity)


func test_motion(_motion: Vector2, _infinite_inertia = true, _margin = 0.08, _result = null):
	if not has_rb:
		return
	return rb.test_motion(_motion, _infinite_inertia, _margin, _result)
