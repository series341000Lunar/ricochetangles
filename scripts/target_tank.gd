class_name V0TargetTank
extends StaticBody3D

@export var target_id := "target"
@export var front_armor_mm := 90.0
@export var side_armor_mm := 55.0
@export var rear_armor_mm := 35.0
@export var auto_ricochet_degrees := 75.0

var _initial_transform: Transform3D


func _ready() -> void:
	_initial_transform = global_transform


func resolve_armor_hit(
	projectile_direction_2d: Vector2,
	hit_point_3d: Vector3,
	penetration_mm: float
) -> Dictionary:
	var result := ArmorLogic2D.resolve_hit(
		Vector2(global_position.x, global_position.z),
		global_rotation.y,
		projectile_direction_2d,
		Vector2(hit_point_3d.x, hit_point_3d.z),
		front_armor_mm,
		side_armor_mm,
		rear_armor_mm,
		penetration_mm,
		auto_ricochet_degrees
	)
	result["target_id"] = target_id
	result["target_position_2d"] = Vector2(global_position.x, global_position.z)
	result["target_yaw_radians"] = global_rotation.y
	return result


func reset_state() -> void:
	global_transform = _initial_transform
