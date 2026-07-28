class_name V0TurretAim
extends Node3D

const AIM_PLANE_Y := 0.0
const AIM_EPSILON := 0.000001
const INITIAL_AIM_POINT := Vector3(0.0, 0.0, -20.0)

@onready var muzzle: Marker3D = $Muzzle

var current_world_aim_point := INITIAL_AIM_POINT
var stored_world_aim_point := INITIAL_AIM_POINT
var mouse_screen_position := Vector2.ZERO
var waiting_for_mouse_after_switch := false
var camera_controller: V0CameraController


func _ready() -> void:
	mouse_screen_position = get_viewport().get_mouse_position()
	update_aim_orientation()


func _process(_delta: float) -> void:
	update_aim_orientation()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_screen_position = event.position
		waiting_for_mouse_after_switch = false
		refresh_aim_from_mouse()


func set_camera_controller(controller: V0CameraController) -> void:
	camera_controller = controller
	if not waiting_for_mouse_after_switch:
		refresh_aim_from_mouse()


func refresh_aim_from_mouse() -> void:
	if camera_controller == null:
		return
	var camera := camera_controller.get_active_camera()
	if camera == null:
		return
	var projected: Variant = compute_world_aim(mouse_screen_position, camera)
	if projected != null:
		current_world_aim_point = projected
		stored_world_aim_point = projected


func compute_world_aim(screen_position: Vector2, camera: Camera3D) -> Variant:
	var ray_origin := camera.project_ray_origin(screen_position)
	var ray_direction := camera.project_ray_normal(screen_position)
	if absf(ray_direction.y) <= AIM_EPSILON:
		return null
	var distance := (AIM_PLANE_Y - ray_origin.y) / ray_direction.y
	if distance < 0.0:
		return null
	return ray_origin + ray_direction * distance


func hold_aim_after_camera_switch(world_aim_point: Vector3) -> void:
	stored_world_aim_point = world_aim_point
	current_world_aim_point = world_aim_point
	waiting_for_mouse_after_switch = true
	update_aim_orientation()


func update_aim_orientation() -> void:
	var flat_direction := current_world_aim_point - global_position
	flat_direction.y = 0.0
	if flat_direction.length_squared() <= AIM_EPSILON:
		return
	var world_yaw := atan2(-flat_direction.x, -flat_direction.z)
	global_rotation = Vector3(0.0, world_yaw, 0.0)


func get_muzzle_transform() -> Transform3D:
	return muzzle.global_transform


func get_aim_error_degrees() -> float:
	var expected := current_world_aim_point - global_position
	expected.y = 0.0
	if expected.length_squared() <= AIM_EPSILON:
		return 0.0
	var actual := -global_transform.basis.z
	actual.y = 0.0
	return rad_to_deg(actual.normalized().angle_to(expected.normalized()))


func set_world_aim_for_validation(world_aim_point: Vector3) -> void:
	current_world_aim_point = world_aim_point
	stored_world_aim_point = world_aim_point
	waiting_for_mouse_after_switch = false
	update_aim_orientation()


func reset_state() -> void:
	current_world_aim_point = INITIAL_AIM_POINT
	stored_world_aim_point = INITIAL_AIM_POINT
	waiting_for_mouse_after_switch = false
	mouse_screen_position = get_viewport().get_mouse_position()
	update_aim_orientation()
