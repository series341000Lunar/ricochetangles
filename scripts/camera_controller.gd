class_name V0CameraController
extends Node3D

enum CameraMode {
	TOP_DOWN,
	OBLIQUE,
}

@export var player_path: NodePath
@export var turret_path: NodePath

@onready var player: Node3D = get_node(player_path)
@onready var turret: V0TurretAim = get_node(turret_path)
@onready var top_down_camera: Camera3D = $TopDownCamera
@onready var oblique_camera: Camera3D = $ObliqueCamera

var active_mode := CameraMode.TOP_DOWN


func _ready() -> void:
	reset_state()


func _process(_delta: float) -> void:
	global_position = Vector3(player.global_position.x, 0.0, player.global_position.z)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_C:
		switch_camera()


func switch_camera() -> void:
	var retained_aim := turret.current_world_aim_point
	active_mode = (
		CameraMode.OBLIQUE
		if active_mode == CameraMode.TOP_DOWN
		else CameraMode.TOP_DOWN
	)
	_apply_camera_mode()
	turret.hold_aim_after_camera_switch(retained_aim)


func _apply_camera_mode() -> void:
	top_down_camera.current = active_mode == CameraMode.TOP_DOWN
	oblique_camera.current = active_mode == CameraMode.OBLIQUE


func get_active_camera() -> Camera3D:
	return top_down_camera if active_mode == CameraMode.TOP_DOWN else oblique_camera


func get_mode_name() -> String:
	return "TOP_DOWN" if active_mode == CameraMode.TOP_DOWN else "OBLIQUE"


func reset_state() -> void:
	active_mode = CameraMode.TOP_DOWN
	_apply_camera_mode()
	global_position = Vector3(player.global_position.x, 0.0, player.global_position.z)
