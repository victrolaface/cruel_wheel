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


# virtual methods
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
	collider = _collider


func get_collider():
	return collider


func set_rigid_body(_rigid_body: RigidBody2D):
	rigid_body = _rigid_body
	var has_col = false
	for child in rigid_body.get_children():
		if child is CollisionShape2D:
			collider = child
			has_col = true
			break
	if has_col:
		var emit_init = false
		var connecting = true
		while connecting:
			connected.received_collider = _on_connect(
				connected.received_collider, "received_collider", "_on_received_collider"
			)
			emit_init = connected.received_collider
			connecting = emit_init
			connected.body_entered = _on_connect(
				connected.body_entered, "body_entered", "_on_body_entered", true
			)
			emit_init = connected.body_entered
			connecting = emit_init
			connected.body_exited = _on_connect(
				connected.body_exited, "body_exited", "_on_body_exited", true
			)
			emit_init = connected.body_exited
			connecting = emit_init
			connected.body_shape_entered = _on_connect(
				connected.body_shape_entered, "body_shape_entered", "_on_body_shape_entered", true
			)
			emit_init = connected.body_shape_entered
			connecting = emit_init
			connected.body_shape_exited = _on_connect(
				connected.body_shape_exited, "body_shape_exited", "_on_body_shape_exited", true
			)
			emit_init = connected.body_shape_exited
			connecting = emit_init
			connected.sleeping_state_changed = _on_connect(
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


# helper methods
func _on_connect(_connect: bool, _signal: String, _method: String, _is_rigid_body = false):
	if not _connect:
		if _is_rigid_body:
			_connect = is_connected(_signal, rigid_body, _method)
		else:
			_connect = is_connected(_signal, self, _method)
		if not _connect:
			if _is_rigid_body:
				_connect = connect(_signal, rigid_body, _method, [], CONNECT_DEFERRED)
			else:
				_connect = connect(_signal, self, _method, [], CONNECT_ONESHOT)
	return _connect


func get_rigid_body():
	return rigid_body


func set_can_sleep(_can_sleep: bool):
	rigid_body.can_sleep = _can_sleep


func get_can_sleep():
	return rigid_body.can_sleep


func set_contact_monitor(_contact_monitor: bool):
	rigid_body.contact_monitor = _contact_monitor


func get_contact_monitor():
	return rigid_body.contact_monitor


func set_sleeping(_sleeping: bool):
	rigid_body.sleeping = _sleeping


func get_sleeping():
	return rigid_body.sleeping


func set_custom_integrator(_custom_integrator: bool):
	rigid_body.custom_integrator = _custom_integrator


func get_custom_integrator():
	return rigid_body.custom_integrator


func set_continuous_cd_mode_disabled(_disabled: bool):
	rigid_body.continuous_cd = _CCD_MODES.DISABLED


func get_continuous_cd_mode_disabled():
	return rigid_body.continuous_cd == _CCD_MODES.DISABLED


func set_continuous_cd_mode_cast_ray(_cast_ray: bool):
	rigid_body.continuous_cd = _CCD_MODES.CAST_RAY


func get_continuous_cd_mode_cast_ray():
	return rigid_body.continuous_cd == _CCD_MODES.CAST_RAY


func set_continuous_cd_mode_cast_shape(_cast_shape: bool):
	rigid_body.continuous_cd = _CCD_MODES.CAST_SHAPE


func get_continuous_cd_mode_cast_shape():
	return rigid_body.continuous_cd == _CCD_MODES.CAST_SHAPE


func set_rough(_rough: bool):
	rigid_body.physics_material_override.rough = _rough


func get_rough():
	return rigid_body.physics_material_override.rough


func set_absorbent(_absorbent: bool):
	rigid_body.physics_material_override.absorbent = _absorbent


func get_absorbent():
	return rigid_body.physics_material_override.absorbent


func set_mode_rigid(_rigid: bool):
	if _rigid:
		rigid_body.mode = _MODES.RIGID


func get_mode_rigid():
	return rigid_body.mode == _MODES.RIGID


func set_mode_static(_static: bool):
	if _static:
		rigid_body.mode = _MODES.STATIC


func get_mode_static():
	return rigid_body.mode == _MODES.STATIC


func set_mode_character(_character: bool):
	if _character:
		rigid_body.mode = _MODES.CHARACTER


func get_mode_character():
	return rigid_body.mode == _MODES.CHARACTER


func set_mode_kinematic(_kinematic: bool):
	if _kinematic:
		rigid_body.mode = _MODES.KINEMATIC


func get_mode_kinematic():
	return rigid_body.mode == _MODES.KINEMATIC


func set_contacts_reported(_contacts_reported: int):
	rigid_body.contacts_reported = _contacts_reported


func get_contacts_reported():
	return rigid_body.contacts_reported


func set_mode(_mode: int):
	if _in_range(_mode, rigid_body.mode, _MODES.RIGID, _MODES.KINEMATIC):
		rigid_body.mode = _mode


func get_mode():
	return rigid_body.continuous_cd


func set_continuous_cd(_cd: int):
	if _in_range(_cd, rigid_body.continous_cd, _CCD_MODES.DISABLED, _CCD_MODES.CAST_SHAPE):
		rigid_body.continuous_cd = _cd


func get_continuous_cd():
	return rigid_body.continuous_cd


func set_angular_damp(_angular_damp: float):
	rigid_body.angular_damp = _angular_damp


func get_angular_damp():
	return rigid_body.angular_damp


func set_angular_velocity(_angular_velocity: float):
	rigid_body.angular_velocity = _angular_velocity


func get_angular_velocity():
	return rigid_body.angular_velocity


func set_applied_torque(_applied_torque: float):
	rigid_body.applied_torque = _applied_torque


func get_applied_torque():
	return rigid_body.applied_torque


func set_gravity_scale(_gravity_scale: float):
	rigid_body.gravity_scale = _gravity_scale


func get_gravity_scale():
	return rigid_body.gravity_scale


func set_inertia(_inertia: float):
	rigid_body.inertia = _inertia


func get_inertia():
	return rigid_body.inertia


func set_linear_damp(_linear_damp: float):
	rigid_body.linear_damp = _linear_damp


func get_linear_damp():
	return rigid_body.linear_damp


func set_mass(_mass: float):
	rigid_body.mass = _mass


func get_mass():
	return rigid_body.mass


func set_weight(_weight: float):
	rigid_body.weight = _weight


func get_weight():
	return rigid_body.weight


func set_friction(_friction: float):
	rigid_body.physics_material_override.friction = _friction


func get_friction():
	return rigid_body.physics_material_override.friction


func set_bounce(_bounce: float):
	rigid_body.physics_material_override.bounce = _bounce


func get_bounce():
	return rigid_body.physics_material_override.bounce


func set_applied_force(_applied_force: Vector2):
	rigid_body.applied_force = _applied_force


func get_applied_force():
	return rigid_body.applied_force


func set_linear_velocity(_linear_velocity: Vector2):
	rigid_body.linear_velocity = _linear_velocity


func get_linear_velocity():
	return rigid_body.linear_velocity


func _in_range(_mode: int, _mode_compare: int, _first: int, _last: int):
	return _mode >= _first && _mode <= _last


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
