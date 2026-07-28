class_name V0Projectile
extends Node3D

signal impact(report: Dictionary)

const SPEED_METERS_PER_SECOND := 42.0
const LIFETIME_SECONDS := 3.0
const PENETRATION_MM := 120.0
const MAX_RICOCHETS := 1
const SEPARATION_OFFSET_METERS := 0.16
const EXCLUDE_TRAVEL_METERS := 0.45
const TARGET_COLLISION_MASK := 2

var projectile_id := 0
var source_id := "player"
var direction_2d := Vector2(0.0, -1.0)
var age_seconds := 0.0
var ricochet_count := 0
var _excluded_rid := RID()
var _exclude_travel_remaining := 0.0


func initialize(
	new_projectile_id: int,
	spawn_position: Vector3,
	spawn_direction_3d: Vector3
) -> void:
	projectile_id = new_projectile_id
	global_position = spawn_position
	direction_2d = Vector2(spawn_direction_3d.x, spawn_direction_3d.z).normalized()
	orient_to_direction()


func _physics_process(delta: float) -> void:
	age_seconds += delta
	if age_seconds >= LIFETIME_SECONDS:
		queue_free()
		return

	var travel_distance := SPEED_METERS_PER_SECOND * delta
	var direction_3d := Vector3(direction_2d.x, 0.0, direction_2d.y)
	var start := global_position
	var intended_end := start + direction_3d * travel_distance
	var query := PhysicsRayQueryParameters3D.create(
		start,
		intended_end,
		TARGET_COLLISION_MASK
	)
	if _excluded_rid.is_valid():
		query.exclude = [_excluded_rid]
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		global_position = intended_end
		_advance_exclusion(travel_distance)
		return

	_process_hit(hit)


func _process_hit(hit: Dictionary) -> void:
	var collider: Object = hit["collider"]
	var physics_hit_point_3d: Vector3 = hit["position"]
	var physics_hit_normal_3d: Vector3 = hit["normal"]
	if collider.has_method("resolve_armor_hit"):
		var armor_result: Dictionary = collider.resolve_armor_hit(
			direction_2d,
			physics_hit_point_3d,
			PENETRATION_MM
		)
		var report := armor_result.duplicate(true)
		report["projectile_id"] = projectile_id
		report["source_id"] = source_id
		report["physics_hit_point_3d"] = physics_hit_point_3d
		report["physics_hit_normal_3d"] = physics_hit_normal_3d
		report["ricochet_count"] = ricochet_count
		impact.emit(report)
		if (
			armor_result["result"] == ArmorLogic2D.RESULT_RICOCHET
			and ricochet_count < MAX_RICOCHETS
		):
			_apply_ricochet(
				armor_result,
				collider.get_rid(),
				physics_hit_point_3d
			)
			return
	else:
		impact.emit({
			"projectile_id": projectile_id,
			"source_id": source_id,
			"target_id": str(collider.name),
			"physics_hit_point_3d": physics_hit_point_3d,
			"physics_hit_normal_3d": physics_hit_normal_3d,
			"result": "OBSTRUCTION",
			"reason": "FIRST_HIT_NOT_ARMORED",
		})
	queue_free()


func _apply_ricochet(
	armor_result: Dictionary,
	collider_rid: RID,
	hit_point_3d: Vector3
) -> void:
	direction_2d = (armor_result["reflected_direction_2d"] as Vector2).normalized()
	ricochet_count += 1
	_excluded_rid = collider_rid
	_exclude_travel_remaining = EXCLUDE_TRAVEL_METERS
	var reflected_3d := Vector3(direction_2d.x, 0.0, direction_2d.y)
	global_position = hit_point_3d + reflected_3d * SEPARATION_OFFSET_METERS
	orient_to_direction()


func validation_apply_ricochet(armor_result: Dictionary) -> void:
	_apply_ricochet(armor_result, RID(), global_position)


func _advance_exclusion(travel_distance: float) -> void:
	if not _excluded_rid.is_valid():
		return
	_exclude_travel_remaining -= travel_distance
	if _exclude_travel_remaining <= 0.0:
		_excluded_rid = RID()


func orient_to_direction() -> void:
	rotation.y = atan2(-direction_2d.x, -direction_2d.y)
