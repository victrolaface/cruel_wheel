tool
class_name PhysicsSmoothInterpolator2D extends Resource

export(bool) var enabled setget set_enabled, get_enabled
export(int, FLAGS, "Translation", "Orientation", "Scale") var interpolate setget set_interpolate, get_interpolate  # = _data.FLAGS.FI_ALL

var data = {"entity_ref": null, "initialized": false, "interpolate": 0, "enabled": false}

var _data = preload("res://src/physics/interpolation/physics_interpolation_data2D.gd")


func set_enabled(_enabled: bool):
	data.enabled = _enabled


func get_enabled():
	return data.enabled


func set_interpolate(_interpolate):
	_data.flags = _interpolate


func get_interpolate():
	return _data.flags


func interpolate_translation(_enable: bool):
	self.interpolate = _interpolate(_data.FLAGS.FI_TRANSLATION, _enable)


func is_interpolating_translation():
	return _is_interpolating(_data.FLAGS.FI_TRANSLATION)


func interpolate_orientation(_enable: bool):  # -> void:
	self.interpolate = _interpolate(data.FLAGS.FI_ORIENTATION, _enable)


func is_interpolating_orientation() -> bool:
	return _is_interpolating(_data.FLAGS.FI_ORIENTATION)


func interpolate_scale(_enable: bool) -> void:
	self.interpolate = _interpolate(_data.FLAGS.FI_SCALE, _enable)


func is_interpolating_scale() -> bool:
	return _is_interpolating(_data.FLAGS.FI_SCALE)


func _interpolate(_flag: int, _enable: bool):
	return PhysicsSmoothInterpolation.bits(self.interpolate, _flag, _enable)


func _is_interpolating(_flag: int):
	return PhysicsSmoothInterpolation.is_enabled(self.interpolate, _flag)


func _init(_entity_ref):
	data.entity_ref = _entity_ref
	data.initialized = data.entity_ref.enabled


#func _ready() -> void:
# If node is initially hidden, must ensure processing is disabled
#set_process(is_visible_in_tree())
#set_physics_process(is_visible_in_tree())
#_interp_data = _SmoothCore.IData2D.new(get_parent())

"""
###############################################################################
# Copyright (c) 2019 Yuri Sarudiansky
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
###############################################################################

# This is largely based on the Lawnjelly's smoothing-addon, which can be found
# here: https://github.com/lawnjelly/smoothing-addon
# In here there are a few notable differences:
# - The target will be automatically assigned to be directly the node
# this is attached to. In other words, the smooth's parent.
# - Internally global transforms are used just so this will automatically
# work regardless of node hierarchy.

extends Node2D
# This is needed in order to static type Smooth2D.
class_name Smooth2D


# If this is set to false then this node will not smoothly follow the target, but
# snap into it. It will take priority over the interpolate flags - which will serve as
# another method to disable interpolation if all flags are set to 0
export var enabled: bool = true
# This property could easily substitute the enabled property, however if "enabled" is removed it may break compatibility
export(int, FLAGS, "Translation", "Orientation", "Scale") var interpolate: int = _SmoothCore.FI_ALL


var _interp_data: _SmoothCore.IData2D


func set_interpolate_translation(enable: bool) -> void:
	interpolate = _SmoothCore.set_bits(interpolate, _SmoothCore.FI_TRANSLATION, enable)

func is_interpolating_translation() -> bool:
	return _SmoothCore.is_enabled(interpolate, _SmoothCore.FI_TRANSLATION)


func set_interpolate_orientation(enable: bool) -> void:
	interpolate = _SmoothCore.set_bits(interpolate, _SmoothCore.FI_ORIENTATION, enable)

func is_interpolating_orientation() -> bool:
	return _SmoothCore.is_enabled(interpolate, _SmoothCore.FI_ORIENTATION)


func set_interpolate_scale(enable: bool) -> void:
	interpolate = _SmoothCore.set_bits(interpolate, _SmoothCore.FI_SCALE, enable)

func is_interpolating_scale() -> bool:
	return _SmoothCore.is_enabled(interpolate, _SmoothCore.FI_SCALE)


func _ready() -> void:
	# If node is initially hidden, must ensure processing is disabled
	set_process(is_visible_in_tree())
	set_physics_process(is_visible_in_tree())
	
	_interp_data = _SmoothCore.IData2D.new(get_parent())


func _process(_dt: float) -> void:
	_interp_data.cycle(false)
	
	if (enabled):
		global_transform = _interp_data.calculate(interpolate)
	
	else:
		global_transform = _interp_data.to


func _physics_process(_dt: float) -> void:
	_interp_data.cycle(true)



func _notification(what: int) -> void:
	match what:
		NOTIFICATION_VISIBILITY_CHANGED:
			set_process(is_visible_in_tree())
			set_physics_process(is_visible_in_tree())


# Teleport/snap to the specified transform
func teleport_to(t: Transform2D) -> void:
	_interp_data.setft(t, t)



func snap_to_target() -> void:
	_interp_data.snap_to_target()

"""
