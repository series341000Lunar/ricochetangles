class_name V01MovingTargetController
extends Node

@export var patrol_distance_meters := 10.0
@export var patrol_speed_meters_per_second := 3.0
@export var patrol_axis_2d := Vector2.RIGHT

var validation_override_active := false
var patrol_progress_meters := 0.0
var direction_sign := 1
var _start_position := Vector3.ZERO
var _target: V0TargetTank


func _ready() -> void:
	_target = get_parent() as V0TargetTank
	_start_position = _target.global_position
	_apply_patrol_transform()


func _physics_process(delta: float) -> void:
	if validation_override_active:
		return
	validation_step(delta)


func validation_step(delta: float) -> void:
	if _target == null or _target.is_destroyed():
		return
	var distance := maxf(patrol_distance_meters, 0.01)
	patrol_progress_meters += (
		patrol_speed_meters_per_second
		* maxf(delta, 0.0)
		* float(direction_sign)
	)
	while patrol_progress_meters > distance or patrol_progress_meters < 0.0:
		if patrol_progress_meters > distance:
			patrol_progress_meters = distance * 2.0 - patrol_progress_meters
			direction_sign = -1
		elif patrol_progress_meters < 0.0:
			patrol_progress_meters = -patrol_progress_meters
			direction_sign = 1
	_apply_patrol_transform()


func reset_state() -> void:
	patrol_progress_meters = 0.0
	direction_sign = 1
	validation_override_active = false
	if _target == null:
		_target = get_parent() as V0TargetTank
	_start_position = _target.global_position
	_apply_patrol_transform()


func get_start_position() -> Vector3:
	return _start_position


func _apply_patrol_transform() -> void:
	var axis := patrol_axis_2d.normalized()
	if axis.length_squared() < 0.000001:
		axis = Vector2.RIGHT
	_target.global_position = (
		_start_position
		+ Vector3(axis.x, 0.0, axis.y) * patrol_progress_meters
	)
	var travel_direction := axis * float(direction_sign)
	_target.rotation.y = atan2(-travel_direction.x, -travel_direction.y)
