class_name V0PlayerTank
extends CharacterBody3D

const MAX_FORWARD_SPEED := 9.0
const MAX_REVERSE_SPEED := 4.5
const ACCELERATION := 8.0
const BRAKING := 14.0
const COAST_DECELERATION := 6.0
const TURN_SPEED_RADIANS := deg_to_rad(105.0)
const WORLD_LIMIT := 29.0

@onready var turret_pivot: V0TurretAim = $TurretPivot

var forward_speed := 0.0
var actual_speed := 0.0
var validation_override_active := false
var _initial_transform: Transform3D


func _ready() -> void:
	_initial_transform = global_transform


func _physics_process(delta: float) -> void:
	if validation_override_active:
		return
	var throttle := (
		float(Input.is_key_pressed(KEY_W))
		- float(Input.is_key_pressed(KEY_S))
	)
	var turn := (
		float(Input.is_key_pressed(KEY_A))
		- float(Input.is_key_pressed(KEY_D))
	)
	_step_movement(throttle, turn, delta)


func _step_movement(throttle: float, turn: float, delta: float) -> void:
	var target_speed := throttle * (
		MAX_FORWARD_SPEED if throttle >= 0.0 else MAX_REVERSE_SPEED
	)
	var rate := COAST_DECELERATION
	if not is_zero_approx(throttle):
		rate = ACCELERATION
		if not is_zero_approx(forward_speed) and signf(forward_speed) != signf(target_speed):
			rate = BRAKING
	forward_speed = move_toward(forward_speed, target_speed, rate * delta)

	rotation.y += turn * TURN_SPEED_RADIANS * delta
	var start_position := global_position
	var forward := -global_transform.basis.z.normalized()
	var collision := move_and_collide(forward * forward_speed * delta)
	if collision != null:
		forward_speed *= 0.25
	global_position.x = clampf(global_position.x, -WORLD_LIMIT, WORLD_LIMIT)
	global_position.z = clampf(global_position.z, -WORLD_LIMIT, WORLD_LIMIT)
	velocity = (global_position - start_position) / maxf(delta, 0.000001)
	actual_speed = Vector2(velocity.x, velocity.z).length()


func validation_step(throttle: float, turn: float, delta: float) -> void:
	validation_override_active = true
	_step_movement(throttle, turn, delta)


func reset_state() -> void:
	global_transform = _initial_transform
	velocity = Vector3.ZERO
	forward_speed = 0.0
	actual_speed = 0.0
	validation_override_active = false
	turret_pivot.reset_state()
