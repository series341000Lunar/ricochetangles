class_name V0TargetTank
extends StaticBody3D

@export var target_id := "target"
@export var front_armor_mm := 90.0
@export var side_armor_mm := 55.0
@export var rear_armor_mm := 35.0
@export var auto_ricochet_degrees := 75.0
@export var damage_enabled := false
@export_range(1, 99, 1) var max_hit_points := 3

enum LifeState {
	ALIVE,
	DESTROYED,
}

var _initial_transform: Transform3D
var _initial_collision_layer := 0
var current_hit_points := 3
var life_state := LifeState.ALIVE
var destroyed_event_count := 0
var _destroyed_material := StandardMaterial3D.new()


func _ready() -> void:
	_initial_transform = global_transform
	_initial_collision_layer = collision_layer
	current_hit_points = maxi(max_hit_points, 1)
	_destroyed_material.albedo_color = Color(0.08, 0.085, 0.09, 1.0)
	_destroyed_material.roughness = 1.0


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
	_apply_combat_result(result)
	return result


func reset_state() -> void:
	global_transform = _initial_transform
	current_hit_points = maxi(max_hit_points, 1)
	life_state = LifeState.ALIVE
	destroyed_event_count = 0
	collision_layer = _initial_collision_layer
	_set_collision_disabled(false)
	_set_destroyed_visual(false)
	var movement_controller := get_node_or_null("MovingTargetController")
	if movement_controller != null and movement_controller.has_method("reset_state"):
		movement_controller.reset_state()


func is_destroyed() -> bool:
	return life_state == LifeState.DESTROYED


func get_life_state_name() -> String:
	return LifeState.keys()[life_state]


func _apply_combat_result(result: Dictionary) -> void:
	var hp_before := current_hit_points
	var damage_applied := 0
	var destroyed_transition := false
	if (
		damage_enabled
		and life_state == LifeState.ALIVE
		and result.get("result", "") == ArmorLogic2D.RESULT_PENETRATION
	):
		current_hit_points = maxi(current_hit_points - 1, 0)
		damage_applied = hp_before - current_hit_points
		if current_hit_points == 0:
			_enter_destroyed_state()
			destroyed_transition = true

	result["damage_enabled"] = damage_enabled
	result["hp_before"] = hp_before
	result["hp_after"] = current_hit_points
	result["max_hit_points"] = max_hit_points
	result["damage_applied"] = damage_applied
	result["target_state"] = get_life_state_name()
	result["destroyed_transition"] = destroyed_transition
	result["destroyed_event_count"] = destroyed_event_count


func _enter_destroyed_state() -> void:
	if life_state == LifeState.DESTROYED:
		return
	life_state = LifeState.DESTROYED
	destroyed_event_count += 1
	collision_layer = 0
	_set_collision_disabled(true)
	_set_destroyed_visual(true)


func _set_collision_disabled(disabled: bool) -> void:
	var collision_shape := get_node_or_null("CollisionShape3D") as CollisionShape3D
	if collision_shape != null:
		collision_shape.set_deferred("disabled", disabled)


func _set_destroyed_visual(destroyed: bool) -> void:
	rotation.z = deg_to_rad(12.0) if destroyed else 0.0
	for node_name in ["Hull", "Turret", "FrontMarker"]:
		var mesh_instance := get_node_or_null(node_name) as MeshInstance3D
		if mesh_instance != null:
			mesh_instance.material_override = _destroyed_material if destroyed else null
