#warning-ignore-all:unused_signal
tool
extends Component
class_name RigidBody2dComponent

signal received_collider(name, id)
signal body_entered(name, id)
signal body_exited(name, id)
signal body_shape_entered(name, id)
signal body_shape_exited(name, id)
signal sleeping_state_changed(name, id)

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

var rigid_body: RigidBody2D setget set_rigid_body, get_rigid_body
var collider: CollisionShape2D setget set_collider, get_collider

const _MODES = {"RIGID": 0, "STATIC": 1, "CHARACTER": 2, "KINEMATIC": 3}
const _CCD_MODES = {"DISABLED": 0, "CAST_RAY": 1, "CAST_SHAPE": 2}
const COMPONENT_NAME = "RigidBody2d"

var connected = {
	"received_collider": false,
	"body_entered": false,
	"body_exited": false,
	"body_shape_entered": false,
	"body_shape_exited": false,
	"sleeping_state_changed": false
}

var state = {
	"has_collider": false,
	"body_entered": false,
	"body_exited": false,
	"body_shape_entered": false,
	"body_shape_exited": false,
	"sleeping_state_changed": false
}


func _init():
	has_collider = is_initialized
	connected.received_collider = has_collider
	rigid_body = null
	collider = null
	name = COMPONENT_NAME
	var is_local = resource_local_to_scene
	if is_local:
		id = get_instance_id()
	else:
		id = get_rid().get_id()
	meta.initialize(name, id, is_local)


# signal functions
func _on_received_collider():
	if not state.has_collider:
		state.has_collider = true
		connected.received_collider = not state.has_collider


"""
_on_body_entered
_on_body_exited
_on_body_shape_entered
_on_body_shape_exited
_on_sleeping_state_changed
"""


# setters, getters
func set_is_initialized(_init: bool):
	pass


func get_is_initialized():
	return meta.state.initialized


func set_has_collider(_has_collider: bool):
	pass


func get_has_collider():
	return state.has_collider


func set_collider(_collider: CollisionShape2D):
	if collider == null && _collider != null:
		collider = _collider


func get_collider():
	return collider


func set_rigid_body(_rigid_body: RigidBody2D):
	if _rigid_body != null && rigid_body == null:
		rigid_body = _rigid_body
		if rigid_body.get_child_count() > 0:
			for child in rigid_body.get_children():
				if child is CollisionShape2D:
					collider = child
					break
		if collider != null:
			var emit_init = false
			var connecting = true
			while connecting:
				connected.received_collider = _connected_on_init(
					connected.received_collider, "received_collider", "_on_received_collider"
				)
				emit_init = connected.received_collider
				connecting = emit_init
				connected.body_entered = _connected_on_init(
					connected.body_entered, "body_entered", "_on_body_entered", true
				)
				emit_init = connected.body_entered
				connecting = emit_init
				connected.body_exited = _connected_on_init(
					connected.body_exited, "body_exited", "_on_body_exited", true
				)
				emit_init = connected.body_exited
				connecting = emit_init
				connected.body_shape_entered = _connected_on_init(
					connected.body_shape_entered,
					"body_shape_entered",
					"_on_body_shape_entered",
					true
				)
				emit_init = connected.body_shape_entered
				connecting = emit_init
				connected.body_shape_exited = _connected_on_init(
					connected.body_shape_exited, "body_shape_exited", "_on_body_shape_exited", true
				)
				emit_init = connected.body_shape_exited
				connecting = emit_init
				connected.sleeping_state_changed = _connected_on_init(
					connected.sleeping_state_changed,
					"sleeping_state_changed",
					"_on_sleeping_state_changed",
					true
				)
				emit_init = connected.sleeping_state_changed
				connecting = not connecting
			if emit_init && meta.state.parented:
				emit_signal("received_collider", meta.name, meta.id)
				emit_signal("enabled", meta.name, meta.id)
				emit_signal("initialized", meta.name, meta.id)


func _connected_on_init(_connected: bool, _signal: String, _method: String, _is_rigid_body = false):
	var _on_connected = _connected
	if not _on_connected:
		if _is_rigid_body:
			_on_connected = is_connected(_signal, rigid_body, _method)
		else:
			_on_connected = is_connected(_signal, self, _method)
		if not _on_connected:
			if _is_rigid_body:
				_on_connected = connect(_signal, rigid_body, _method, [], CONNECT_DEFERRED)
			else:
				_on_connected = connect(_signal, self, _method, [], CONNECT_ONESHOT)
	return _on_connected


func get_rigid_body():
	return rigid_body


func set_can_sleep(_can_sleep: bool):
	if rigid_body != null:
		rigid_body.can_sleep = _can_sleep


func get_can_sleep():
	var _can_sleep = true
	if rigid_body != null:
		_can_sleep = rigid_body.can_sleep
	return _can_sleep


func set_contact_monitor(_contact_monitor: bool):
	if rigid_body != null:
		rigid_body.contact_monitor = _contact_monitor


func get_contact_monitor():
	var _contact_monitor = false
	if rigid_body != null:
		_contact_monitor = rigid_body.contact_monitor
	return _contact_monitor


func set_sleeping(_sleeping: bool):
	if rigid_body != null:
		rigid_body.sleeping = _sleeping


func get_sleeping():
	var _sleeping = false
	if rigid_body != null:
		_sleeping = rigid_body.sleeping
	return _sleeping


func set_custom_integrator(_custom_integrator: bool):
	if rigid_body != null:
		rigid_body.custom_integrator = _custom_integrator


func get_custom_integrator():
	var _custom_integrator = false
	if rigid_body != null:
		_custom_integrator = rigid_body.custom_integrator
	return _custom_integrator


func set_continuous_cd_mode_disabled(_disabled: bool):
	if _can_set_ccd_mode(_disabled, _CCD_MODES.DISABLED):
		rigid_body.continuous_cd = _CCD_MODES.DISABLED


func get_continuous_cd_mode_disabled():
	return _is_ccd_mode(_CCD_MODES.DISABLED)


func set_continuous_cd_mode_cast_ray(_cast_ray: bool):
	if _can_set_ccd_mode(_cast_ray, _CCD_MODES.CAST_RAY):
		rigid_body.continuous_cd = _CCD_MODES.CAST_RAY


func get_continuous_cd_mode_cast_ray():
	return _is_ccd_mode(_CCD_MODES.CAST_RAY)


func set_continuous_cd_mode_cast_shape(_cast_shape: bool):
	if _can_set_ccd_mode(_cast_shape, _CCD_MODES.CAST_SHAPE):
		rigid_body.continuous_cd = _CCD_MODES.CAST_SHAPE


func get_continuous_cd_mode_cast_shape():
	return _is_ccd_mode(_CCD_MODES.CAST_SHAPE)


func set_rough(_rough: bool):
	if _has_physics_mat():
		rigid_body.physics_material_override.rough = _rough


func get_rough():
	var _rough = false
	if _has_physics_mat():
		_rough = rigid_body.physics_material_override.rough
	return _rough


func set_absorbent(_absorbent: bool):
	if _has_physics_mat():
		rigid_body.physics_material_override.absorbent = _absorbent


func get_absorbent():
	var is_absorbent = false
	if _has_physics_mat():
		is_absorbent = rigid_body.physics_material_override.absorbent
	return is_absorbent


func set_mode_rigid(_rigid: bool):
	if _can_set_mode(_rigid, _MODES.RIGID):
		rigid_body.mode = _MODES.RIGID


func get_mode_rigid():
	return _is_mode(_MODES.RIGID)


func set_mode_static(_static: bool):
	if _can_set_mode(_static, _MODES.STATIC):
		rigid_body.mode = _MODES.STATIC


func get_mode_static():
	return _is_mode(_MODES.STATIC)


func set_mode_character(_character: bool):
	if _can_set_mode(_character, _MODES.CHARACTER):
		rigid_body.mode = _MODES.CHARACTER


func get_mode_character():
	return _is_mode(_MODES.CHARACTER)


func set_mode_kinematic(_kinematic: bool):
	if _can_set_mode(_kinematic, _MODES.KINEMATIC):
		rigid_body.mode = _MODES.KINEMATIC


func get_mode_kinematic():
	return _is_mode(_MODES.KINEMATIC)


func set_contacts_reported(_contacts_reported: int):
	if rigid_body != null && _contacts_reported >= 0:
		rigid_body.contacts_reported = _contacts_reported


func get_contacts_reported():
	var _contacts_reported = 0
	if rigid_body != null:
		_contacts_reported = rigid_body.contacts_reported
	return _contacts_reported


func set_mode(_mode: int):
	if _can_set_mode_in_range(_mode, rigid_body.mode, _MODES.RIGID, _MODES.KINEMATIC):
		rigid_body.mode = _mode


func get_mode():
	var _mode = 0
	if rigid_body != null:
		_mode = rigid_body.continuous_cd
	return mode


func set_continuous_cd(_continuous_cd: int):
	if _can_set_mode_in_range(
		_continuous_cd, rigid_body.continous_cd, _CCD_MODES.DISABLED, _CCD_MODES.CAST_SHAPE
	):
		rigid_body.continuous_cd = _continuous_cd


func get_continuous_cd():
	var _continuous_cd = 0
	if rigid_body != null:
		_continuous_cd = rigid_body.continuous_cd
	return _continuous_cd


func set_angular_damp(_angular_damp: float):
	if rigid_body != null:
		rigid_body.angular_damp = _angular_damp


func get_angular_damp():
	var _angular_damp = 1.0
	if rigid_body != null:
		angular_damp = rigid_body.angular_damp
	return _angular_damp


func set_angular_velocity(_angular_velocity: float):
	if rigid_body != null:
		rigid_body.angular_velocity = _angular_velocity


func get_angular_velocity():
	var _angular_velocity = 0.0
	if rigid_body != null:
		_angular_velocity = rigid_body.angular_velocity
	return _angular_velocity


func set_applied_torque(_applied_torque: float):
	if rigid_body != null:
		rigid_body.applied_torque = _applied_torque


func get_applied_torque():
	var _applied_torque = 0.0
	if rigid_body != null:
		_applied_torque = rigid_body.applied_torque
	return _applied_torque


func set_gravity_scale(_gravity_scale: float):
	if rigid_body != null:
		rigid_body.gravity_scale = _gravity_scale


func get_gravity_scale():
	var _gravity_scale = 1.0
	if rigid_body != null:
		_gravity_scale = rigid_body.gravity_scale
	return _gravity_scale


func set_inertia(_inertia: float):
	if rigid_body != null:
		rigid_body.inertia = _inertia


func get_inertia():
	var _inertia = 0.0
	if rigid_body != null:
		_inertia = rigid_body.inertia
	return _inertia


func set_linear_damp(_linear_damp: float):
	if rigid_body != null:
		rigid_body.linear_damp = _linear_damp


func get_linear_damp():
	var _linear_damp = -1.0
	if rigid_body != null:
		_linear_damp = rigid_body.linear_damp
	return _linear_damp


func set_mass(_mass: float):
	if rigid_body != null:
		rigid_body.mass = _mass


func get_mass():
	var _mass = 1.0
	if rigid_body != null:
		_mass = rigid_body.mass
	return _mass


func set_weight(_weight: float):
	if rigid_body != null:
		rigid_body.weight = _weight


func get_weight():
	var _weight = 9.8
	if rigid_body != null:
		_weight = rigid_body.weight
	return _weight


func set_friction(_friction: float):
	if _has_physics_mat():
		rigid_body.physics_material_override.friction = _friction


func get_friction():
	var _friction = 1.0
	if _has_physics_mat():
		_friction = rigid_body.physics_material_override.friction
	return _friction


func set_bounce(_bounce: float):
	if _has_physics_mat():
		rigid_body.physics_material_override.bounce = _bounce


func get_bounce():
	var _bounce = 0.0
	if _has_physics_mat():
		_bounce = rigid_body.physics_material_override.bounce
	return _bounce


func set_applied_force(_applied_force: Vector2):
	if rigid_body != null:
		rigid_body.applied_force = _applied_force


func get_applied_force():
	var _applied_force = Vector2(0, 0)
	if rigid_body != null:
		_applied_force = rigid_body.applied_force
	return _applied_force


func set_linear_velocity(_linear_velocity: Vector2):
	if rigid_body != null:
		rigid_body.linear_velocity = _linear_velocity


func get_linear_velocity():
	var _linear_velocity = Vector2(0, 0)
	if rigid_body != null:
		_linear_velocity = rigid_body.linear_velocity
	return _linear_velocity


# setters, getters helper functions
func _can_set_ccd_mode(_is_mode: bool, _ccd_mode: int):
	return rigid_body != null && _is_mode && rigid_body.continuous_cd != _ccd_mode


func _is_ccd_mode(_ccd_mode: int):
	return rigid_body != null && rigid_body.continuous_cd == _ccd_mode


func _has_physics_mat():
	return rigid_body != null && rigid_body.physics_material_override != null


func _can_set_mode(_set_mode: bool, _mode: int):
	return rigid_body != null && _set_mode && rigid_body.mode != _mode


func _can_set_mode_in_range(_mode: int, _mode_compare: int, _first: int, _last: int):
	return rigid_body != null && _mode >= _first && _mode <= _last && _mode != _mode_compare


func _is_mode(_mode: int):
	return rigid_body != null && rigid_body.mode == _mode


# adapted methods
func initegrate_forces(_state: Physics2DDirectBodyState):
	if rigid_body != null:
		rigid_body.integrate_forces(_state)


func add_central_force(_force: Vector2):
	if rigid_body != null:
		rigid_body.add_central_force(_force)


func add_force(_offset: Vector2, _force: Vector2):
	if rigid_body != null:
		rigid_body.add_force(_offset, _force)


func add_torque(_torque: float):
	if rigid_body != null:
		rigid_body.add_torque(_torque)


func apply_central_impulse(_impulse: Vector2):
	if rigid_body != null:
		rigid_body.apply_central_impulse(_impulse)


func apply_impulse(_offset: Vector2, _impulse: Vector2):
	if rigid_body != null:
		rigid_body.apply_impulse(_offset, _impulse)


func apply_torque_impulse(_torque: float):
	if rigid_body != null:
		rigid_body.apply_torque_impulse(_torque)


func get_colliding_bodies():
	var col_bodies = null
	if rigid_body != null:
		col_bodies = rigid_body.get_colliding_bodies()
	return col_bodies


func set_axis_velocity(_axis_velocity: Vector2):
	if rigid_body != null:
		rigid_body.set_axis_velocity(_axis_velocity)


func test_motion(_motion: Vector2, _infinite_inertia = true, _margin = 0.08, _result = null):
	var res = false
	if rigid_body != null:
		res = rigid_body.test_motion(_motion, _infinite_inertia, _margin, _result)
	return res
