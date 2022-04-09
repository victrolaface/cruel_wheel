#warning-ignore-all:unused_signal
tool
extends Component
class_name RigidBody2dComponent

"""
signal received_collider(name, id)
signal body_entered(name, id, body)
signal body_exited(name, id, body)
signal body_shape_entered(name, id, body_rid, body, body_shape_index, local_shape_index)
signal body_shape_exited(name, id, body_rid, body, body_shape_index, local_shape_index)
signal sleeping_state_changed(name, id)
signal rigid_body_changed(name, id)
signal rigid_body_predelete(name, id)
signal collision_body_2d_changed(name, id)
signal collision_body_2d_predelete(name, id)
"""
"""
export(bool) var is_initialized setget set_is_initialized, get_is_initialized
export(bool) var has_collider setget set_has_collider, get_has_collider
export(bool) var can_sleep setget set_can_sleep, get_can_sleep
export(bool) var contact_monitor setget set_contact_monitor, get_contact_monitor
export(bool) var sleeping setget set_sleeping, get_sleeping
export(bool) var custom_integrator setget set_custom_integrator, get_custom_integrator
export(bool) var continuous_cd_mode_disabled setget set_continuous_cd_mode_disabled, get_continuous_cd_mode_disabled
export(bool) var continuous_cd_mode_cast_ray setget set_continuous_cd_mode_cast_ray, get_continuous_cd_mode_cast_ray
export(bool) var continuous_cd_mode_shape setget set_continuous_cd_mode_cast_shape, get_continuous_cd_mode_cast_shape
export(bool) var rough setget set_rough, get_rough
export(bool) var absorbent setget set_absorbent, get_absorbent
export(bool) var mode_rigid setget set_mode_rigid, get_mode_rigid
export(bool) var mode_static setget set_mode_static, get_mode_static
export(bool) var mode_character setget set_mode_character, get_mode_character
export(bool) var mode_kinematic setget set_mode_kinematic, get_mode_kinematic
export(int) var contacts_reported setget set_contacts_reported, get_contacts_reported
export(int) var mode setget set_mode, get_mode
export(int) var continuous_cd setget set_continuous_cd, get_continuous_cd
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
"""

#var rigid_body: RigidBody2D setget set_rigid_body, get_rigid_body
#var collider: CollisionShape2D setget set_collider, get_collider

#var data = preload("rigid_body_2d_component_data.gd")

#var entered_body: Node setget set_entered_body, get_entered_body
#var entered_bodies_by_id: Dictionary setget set_entered_bodies_by_id, get_entered_bodies_by_id

#func set_entered_body(_body: Node):
#	pass

#func get_entered_body():
#	return entered_body
#func set_entered_bodies_by_id

#const _MODES = {"RIGID": 0, "STATIC": 1, "CHARACTER": 2, "KINEMATIC": 3}
#const _CCD_MODES = {"DISABLED": 0, "CAST_RAY": 1, "CAST_SHAPE": 2}
#const COMPONENT_NAME = "RigidBody2d"

#var connected = {
#	"received_collider": false,
#	"body_entered": false,
#	"body_exited": false,
#	"body_shape_entered": false,
#	"body_shape_exited": false,
#	"sleeping_state_changed": false
#}

#var state = {
#	"has_collider": false, "body_entered": false, "body_shape_entered": false, "sleeping": false
#}

# virtual methods
"""
func _init():
	has_collider = is_initialized
	connected.received_collider = has_collider
	rigid_body = null
	collider = null
	meta.name = COMPONENT_NAME
	var is_local = resource_local_to_scene
	if is_local:
		meta.id = get_instance_id()
	else:
		meta.id = get_rid().get_id()
	initialize(is_local)


# signal functions
func _on_received_collider():
	state.has_collider = true
	connected.received_collider = not state.has_collider


func _on_body_entered(_body: Node):
	#entered_body = _body
	state.body_entered = true


func _on_body_exited(_body: Node):
	state.body_entered = false


func _on_body_shape_entered():
	state.body_shape_entered = true


func _on_body_shape_exited():
	state.body_shape_entered = false


func _on_sleeping_state_changed():
	state.sleeping = not state.sleeping

"""
# setters, getters

"""
# adapted methods
func initegrate_forces(_state: Physics2DDirectBodyState):
	rigid_body.integrate_forces(_state)


func add_central_force(_force: Vector2):
	rigid_body.add_central_force(_force)


func add_force(_offset: Vector2, _force: Vector2):
	rigid_body.add_force(_offset, _force)


func add_torque(_torque: float):
	rigid_body.add_torque(_torque)


func apply_central_impulse(_impulse: Vector2):
	rigid_body.apply_central_impulse(_impulse)


func apply_impulse(_offset: Vector2, _impulse: Vector2):
	rigid_body.apply_impulse(_offset, _impulse)


func apply_torque_impulse(_torque: float):
	rigid_body.apply_torque_impulse(_torque)


func get_colliding_bodies():
	return rigid_body.get_colliding_bodies()


func set_axis_velocity(_axis_velocity: Vector2):
	rigid_body.set_axis_velocity(_axis_velocity)


func test_motion(_motion: Vector2, _infinite_inertia = true, _margin = 0.08, _result = null):
	return rigid_body.test_motion(_motion, _infinite_inertia, _margin, _result)
"""
