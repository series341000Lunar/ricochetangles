extends SceneTree

const TEST_RANGE_SCENE := preload("res://scenes/test_range.tscn")
const PROJECTILE_SCRIPT := preload("res://scripts/projectile.gd")

var _results: Dictionary = {}
var _failure_details := PackedStringArray()


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var test_range: V0TestRange = TEST_RANGE_SCENE.instantiate()
	root.add_child(test_range)
	await process_frame
	await physics_frame

	var moving_targets := get_nodes_in_group("v01_moving_target")
	if moving_targets.size() != 1:
		_record(
			"V0.1-T01",
			false,
			"expected exactly one moving target, found %d" % moving_targets.size()
		)
		await _finish(test_range)
		return

	var target := moving_targets[0] as V0TargetTank
	var controller := target.get_node("MovingTargetController") as V01MovingTargetController
	_test_t01_deterministic_movement_and_aim(test_range, target, controller)
	_test_t02_armor_while_moving_and_camera_independence(test_range, target, controller)
	await _test_t03_damage_distinction_and_single_projectile(test_range, target, controller)
	await _test_t04_three_penetrations_destroy_once(target, controller)
	await _test_t05_full_reset(test_range, target, controller)
	await _finish(test_range)


func _test_t01_deterministic_movement_and_aim(
	test_range: V0TestRange,
	target: V0TargetTank,
	controller: V01MovingTargetController
) -> void:
	test_range.reset_range()
	controller.validation_override_active = true
	for index in range(60):
		controller.validation_step(1.0 / 60.0)
	var position_60_hz := target.global_position

	test_range.reset_range()
	controller.validation_override_active = true
	for index in range(30):
		controller.validation_step(1.0 / 30.0)
	var position_30_hz := target.global_position

	test_range.reset_range()
	controller.validation_override_active = true
	controller.validation_step(4.0)
	var reversed := controller.direction_sign == -1
	var top_down_aim_ok := _camera_aims_at_world_point(
		test_range.turret,
		test_range.camera_controller.top_down_camera,
		target.global_position
	)
	var oblique_aim_ok := _camera_aims_at_world_point(
		test_range.turret,
		test_range.camera_controller.oblique_camera,
		target.global_position
	)
	_record(
		"V0.1-T01",
		(
			get_nodes_in_group("v01_moving_target").size() == 1
			and position_60_hz.distance_to(position_30_hz) < 0.01
			and position_60_hz.distance_to(controller.get_start_position()) > 2.9
			and reversed
			and top_down_aim_ok
			and oblique_aim_ok
		),
		"one target, delta patrol 60/30Hz error=%.4f, reversal=%s, both camera aim=%s/%s" % [
			position_60_hz.distance_to(position_30_hz),
			str(reversed),
			str(top_down_aim_ok),
			str(oblique_aim_ok),
		]
	)


func _test_t02_armor_while_moving_and_camera_independence(
	test_range: V0TestRange,
	target: V0TargetTank,
	controller: V01MovingTargetController
) -> void:
	test_range.reset_range()
	controller.validation_override_active = true
	controller.validation_step(0.75)
	var forward := _target_forward_2d(target)
	var hit_point := _hit_point_3d(target, forward)
	test_range.camera_controller.reset_state()
	var top_down_result := target.resolve_armor_hit(-forward, hit_point, 0.0)
	test_range.camera_controller.switch_camera()
	var oblique_result := target.resolve_armor_hit(-forward, hit_point, 0.0)
	var same_result: bool = (
		top_down_result["armor_zone"] == oblique_result["armor_zone"]
		and top_down_result["result"] == oblique_result["result"]
		and (
			top_down_result["logical_armor_normal_2d"] as Vector2
		).is_equal_approx(oblique_result["logical_armor_normal_2d"])
		and is_equal_approx(
			top_down_result["effective_armor_mm"],
			oblique_result["effective_armor_mm"]
		)
	)
	_record(
		"V0.1-T02",
		(
			same_result
			and top_down_result["armor_zone"] == "FRONT"
			and not top_down_result.has("physics_hit_normal_3d")
			and top_down_result["logical_armor_normal_2d"] is Vector2
			and target.current_hit_points == 3
		),
		"moving yaw=%.2f rad, camera-independent %s/%s, logical normal remains 2D" % [
			target.global_rotation.y,
			top_down_result["armor_zone"],
			top_down_result["result"],
		]
	)


func _test_t03_damage_distinction_and_single_projectile(
	test_range: V0TestRange,
	target: V0TargetTank,
	controller: V01MovingTargetController
) -> void:
	test_range.reset_range()
	controller.validation_override_active = true
	var forward := _target_forward_2d(target)
	var hit_point := _hit_point_3d(target, forward)
	var projectile: V0Projectile = PROJECTILE_SCRIPT.new()
	var reports: Array[Dictionary] = []
	projectile.impact.connect(func(report: Dictionary) -> void: reports.append(report))
	test_range.projectile_root.add_child(projectile)
	projectile.direction_2d = -forward
	projectile._process_hit({
		"collider": target,
		"position": hit_point,
		"normal": Vector3.UP,
	})
	await process_frame
	var hp_after_penetration := target.current_hit_points

	var non_penetration := target.resolve_armor_hit(-forward, hit_point, 1.0)
	var hp_after_non_penetration := target.current_hit_points
	var tangent := Vector2(-forward.y, forward.x)
	var ricochet_direction := (
		-forward * cos(deg_to_rad(80.0))
		+ tangent * sin(deg_to_rad(80.0))
	).normalized()
	var ricochet := target.resolve_armor_hit(ricochet_direction, hit_point, 120.0)
	var hp_after_ricochet := target.current_hit_points
	var one_projectile_one_damage: bool = (
		reports.size() == 1
		and reports[0].get("damage_applied", 0) == 1
		and reports[0].has("physics_hit_normal_3d")
		and reports[0].has("logical_armor_normal_2d")
	)
	_record(
		"V0.1-T03",
		(
			hp_after_penetration == 2
			and non_penetration["result"] == ArmorLogic2D.RESULT_NON_PENETRATION
			and hp_after_non_penetration == 2
			and ricochet["result"] == ArmorLogic2D.RESULT_RICOCHET
			and hp_after_ricochet == 2
			and one_projectile_one_damage
		),
		"HP 3->%d, non-pen=%d, ricochet=%d, projectile reports=%d" % [
			hp_after_penetration,
			hp_after_non_penetration,
			hp_after_ricochet,
			reports.size(),
		]
	)


func _test_t04_three_penetrations_destroy_once(
	target: V0TargetTank,
	controller: V01MovingTargetController
) -> void:
	target.reset_state()
	controller.validation_override_active = true
	var forward := _target_forward_2d(target)
	var hit_point := _hit_point_3d(target, forward)
	var hp_sequence := PackedInt32Array()
	for index in range(3):
		target.resolve_armor_hit(-forward, hit_point, 120.0)
		hp_sequence.append(target.current_hit_points)
	var position_at_destroy := target.global_position
	controller.validation_step(1.0)
	var stopped_after_destroy := target.global_position.is_equal_approx(position_at_destroy)
	var duplicate := target.resolve_armor_hit(-forward, hit_point, 120.0)
	await process_frame
	await physics_frame
	var collision_shape := target.get_node("CollisionShape3D") as CollisionShape3D
	_record(
		"V0.1-T04",
		(
			hp_sequence == PackedInt32Array([2, 1, 0])
			and target.is_destroyed()
			and target.destroyed_event_count == 1
			and duplicate["damage_applied"] == 0
			and duplicate["destroyed_transition"] == false
			and stopped_after_destroy
			and target.collision_layer == 0
			and collision_shape.disabled
		),
		"HP sequence=%s, state=%s, destroy events=%d, collider disabled=%s" % [
			str(hp_sequence),
			target.get_life_state_name(),
			target.destroyed_event_count,
			str(collision_shape.disabled),
		]
	)


func _test_t05_full_reset(
	test_range: V0TestRange,
	target: V0TargetTank,
	controller: V01MovingTargetController
) -> void:
	for cycle in range(2):
		if not target.is_destroyed():
			_destroy_target(target)
		test_range.fire_aphe()
		test_range.debug_overlay.last_report = {"result": "STALE"}
		test_range.camera_controller.switch_camera()
		test_range.reset_range()
		controller.validation_override_active = true
		await process_frame
		await physics_frame

	var collision_shape := target.get_node("CollisionShape3D") as CollisionShape3D
	var hull := target.get_node("Hull") as MeshInstance3D
	var restored_position := target.global_position.is_equal_approx(
		controller.get_start_position()
	)
	var restored_yaw := is_equal_approx(target.global_rotation.y, -PI * 0.5)
	var reset_passed := (
		target.current_hit_points == 3
		and not target.is_destroyed()
		and target.destroyed_event_count == 0
		and restored_position
		and restored_yaw
		and controller.patrol_progress_meters == 0.0
		and controller.direction_sign == 1
		and target.collision_layer == 2
		and not collision_shape.disabled
		and hull.material_override == null
		and test_range.projectile_root.get_child_count() == 0
		and test_range.debug_overlay.last_report.is_empty()
		and (
			test_range.camera_controller.active_mode
			== V0CameraController.CameraMode.TOP_DOWN
		)
	)
	var position_before_resume := target.global_position
	controller.validation_step(0.5)
	var movement_resumed := target.global_position.distance_to(position_before_resume) > 1.4
	_record(
		"V0.1-T05",
		reset_passed and movement_resumed,
		"two resets restore HP/state/start/yaw/direction/collider/visual/debug; resumed=%s" % [
			str(movement_resumed),
		]
	)


func _destroy_target(target: V0TargetTank) -> void:
	var forward := _target_forward_2d(target)
	var hit_point := _hit_point_3d(target, forward)
	for index in range(3):
		target.resolve_armor_hit(-forward, hit_point, 120.0)


func _camera_aims_at_world_point(
	turret: V0TurretAim,
	camera: Camera3D,
	world_point: Vector3
) -> bool:
	var screen_point := camera.unproject_position(world_point)
	var resolved: Variant = turret.compute_world_aim(screen_point, camera)
	return (
		resolved != null
		and (resolved as Vector3).distance_to(
			Vector3(world_point.x, 0.0, world_point.z)
		) < 0.05
	)


func _target_forward_2d(target: V0TargetTank) -> Vector2:
	return Vector2(
		-sin(target.global_rotation.y),
		-cos(target.global_rotation.y)
	).normalized()


func _hit_point_3d(target: V0TargetTank, normal_2d: Vector2) -> Vector3:
	return target.global_position + Vector3(normal_2d.x, 0.7, normal_2d.y) * 2.2


func _record(test_id: String, passed: bool, detail: String) -> void:
	_results[test_id] = "PASS" if passed else "FAIL"
	print("%s detail: %s" % [test_id, detail])
	if not passed:
		_failure_details.append("%s failed: %s" % [test_id, detail])


func _finish(test_range: V0TestRange) -> void:
	for test_id in [
		"V0.1-T01",
		"V0.1-T02",
		"V0.1-T03",
		"V0.1-T04",
		"V0.1-T05",
	]:
		print("%s %s" % [test_id, _results.get(test_id, "FAIL")])
	for detail in _failure_details:
		push_error(detail)
	test_range.queue_free()
	await process_frame
	var failed := _failure_details.size() > 0
	print("V01_AUTOMATED_SUMMARY PASS=%d FAIL=%d" % [
		5 - _failure_details.size(),
		_failure_details.size(),
	])
	quit(1 if failed else 0)
