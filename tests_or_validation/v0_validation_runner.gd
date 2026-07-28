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

	_test_t01_movement_and_turret(test_range)
	_test_t02_top_down_aim(test_range)
	_test_t03_oblique_aim(test_range)
	_test_t04_camera_switch(test_range)
	_test_t05_front_armor()
	_test_t06_side_and_rear_armor()
	_test_t07_target_yaw()
	_test_t08_ricochet_direction()
	await _test_t09_repeated_reset(test_range)

	for test_id in [
		"V0-T01",
		"V0-T02",
		"V0-T03",
		"V0-T04",
		"V0-T05",
		"V0-T06",
		"V0-T07",
		"V0-T08",
		"V0-T09",
	]:
		print("%s %s" % [test_id, _results.get(test_id, "FAIL")])
	for detail in _failure_details:
		push_error(detail)

	test_range.queue_free()
	await process_frame
	var failed := _failure_details.size() > 0
	print("V0_AUTOMATED_SUMMARY PASS=%d FAIL=%d" % [
		9 - _failure_details.size(),
		_failure_details.size(),
	])
	quit(1 if failed else 0)


func _test_t01_movement_and_turret(test_range: V0TestRange) -> void:
	var player := test_range.player
	var turret := test_range.turret
	player.reset_state()
	player.validation_override_active = true
	for index in range(60):
		player.validation_step(1.0, 0.0, 1.0 / 60.0)
	var sixty_hz_distance := -player.global_position.z

	player.reset_state()
	player.validation_override_active = true
	for index in range(30):
		player.validation_step(1.0, 0.0, 1.0 / 30.0)
	var thirty_hz_distance := -player.global_position.z

	player.reset_state()
	player.validation_override_active = true
	turret.set_world_aim_for_validation(Vector3(0.0, 0.0, -20.0))
	for index in range(30):
		player.validation_step(0.0, 1.0, 1.0 / 60.0)
	turret.update_aim_orientation()
	var turret_error := turret.get_aim_error_degrees()
	var passed := (
		sixty_hz_distance > 3.0
		and absf(sixty_hz_distance - thirty_hz_distance) < 0.25
		and absf(player.global_rotation.y) > 0.5
		and turret_error < 0.01
	)
	_record(
		"V0-T01",
		passed,
		"movement distance 60Hz=%.3f, 30Hz=%.3f, turret error=%.4f°" % [
			sixty_hz_distance,
			thirty_hz_distance,
			turret_error,
		]
	)
	player.reset_state()


func _test_t02_top_down_aim(test_range: V0TestRange) -> void:
	test_range.camera_controller.reset_state()
	var camera := test_range.camera_controller.get_active_camera()
	_record(
		"V0-T02",
		_projection_roundtrip_is_accurate(test_range.turret, camera),
		"top-down center and edge ray-plane roundtrip"
	)


func _test_t03_oblique_aim(test_range: V0TestRange) -> void:
	if test_range.camera_controller.active_mode == V0CameraController.CameraMode.TOP_DOWN:
		test_range.camera_controller.switch_camera()
	var camera := test_range.camera_controller.get_active_camera()
	_record(
		"V0-T03",
		_projection_roundtrip_is_accurate(test_range.turret, camera),
		"oblique center and edge ray-plane roundtrip"
	)


func _test_t04_camera_switch(test_range: V0TestRange) -> void:
	var turret := test_range.turret
	var cameras := test_range.camera_controller
	var retained := Vector3(7.5, 0.0, -13.25)
	turret.set_world_aim_for_validation(retained)
	var mode_before := cameras.active_mode
	cameras.switch_camera()
	var retained_after_switch := turret.current_world_aim_point.is_equal_approx(retained)
	var stored_after_switch := turret.stored_world_aim_point.is_equal_approx(retained)
	var held := turret.waiting_for_mouse_after_switch
	var mouse_event := InputEventMouseMotion.new()
	mouse_event.position = get_root().get_visible_rect().size * 0.55
	turret._unhandled_input(mouse_event)
	var released_on_motion := not turret.waiting_for_mouse_after_switch
	_record(
		"V0-T04",
		(
			cameras.active_mode != mode_before
			and retained_after_switch
			and stored_after_switch
			and held
			and released_on_motion
		),
		"world aim retained until the first mouse motion"
	)


func _test_t05_front_armor() -> void:
	var perpendicular := ArmorLogic2D.resolve_hit(
		Vector2.ZERO,
		0.0,
		Vector2(0.0, 1.0),
		Vector2(0.0, -2.0),
		90.0,
		55.0,
		35.0,
		120.0,
		75.0
	)
	var angled := ArmorLogic2D.resolve_hit(
		Vector2.ZERO,
		0.0,
		Vector2(0.8660254, 0.5),
		Vector2(0.0, -2.0),
		90.0,
		55.0,
		35.0,
		120.0,
		75.0
	)
	var ricochet := _front_ricochet_case()
	_record(
		"V0-T05",
		(
			perpendicular["armor_zone"] == "FRONT"
			and perpendicular["result"] == ArmorLogic2D.RESULT_PENETRATION
			and absf(perpendicular["incidence_angle_degrees"]) < 0.01
			and angled["result"] == ArmorLogic2D.RESULT_NON_PENETRATION
			and ricochet["result"] == ArmorLogic2D.RESULT_RICOCHET
		),
		"front perpendicular, angled effective armor, and auto-ricochet"
	)


func _test_t06_side_and_rear_armor() -> void:
	var side := ArmorLogic2D.resolve_hit(
		Vector2.ZERO,
		0.0,
		Vector2(-1.0, 0.0),
		Vector2(2.0, 0.0),
		90.0,
		55.0,
		35.0,
		70.0,
		75.0
	)
	var rear := ArmorLogic2D.resolve_hit(
		Vector2.ZERO,
		0.0,
		Vector2(0.0, -1.0),
		Vector2(0.0, 2.0),
		90.0,
		55.0,
		35.0,
		40.0,
		75.0
	)
	_record(
		"V0-T06",
		(
			side["armor_zone"] == "SIDE"
			and is_equal_approx(side["base_armor_mm"], 55.0)
			and side["result"] == ArmorLogic2D.RESULT_PENETRATION
			and rear["armor_zone"] == "REAR"
			and is_equal_approx(rear["base_armor_mm"], 35.0)
			and rear["result"] == ArmorLogic2D.RESULT_PENETRATION
		),
		"side=55mm and rear=35mm profiles selected"
	)


func _test_t07_target_yaw() -> void:
	var yaw_zero := ArmorLogic2D.resolve_hit(
		Vector2.ZERO,
		0.0,
		Vector2(0.0, 1.0),
		Vector2(0.0, -2.0),
		90.0,
		55.0,
		35.0,
		70.0,
		75.0
	)
	var yaw_ninety := ArmorLogic2D.resolve_hit(
		Vector2.ZERO,
		PI * 0.5,
		Vector2(0.0, 1.0),
		Vector2(0.0, -2.0),
		90.0,
		55.0,
		35.0,
		70.0,
		75.0
	)
	_record(
		"V0-T07",
		(
			yaw_zero["armor_zone"] == "FRONT"
			and yaw_ninety["armor_zone"] == "SIDE"
			and not is_equal_approx(
				yaw_zero["base_armor_mm"],
				yaw_ninety["base_armor_mm"]
			)
		),
		"fixed projectile and hit point change zone when only target yaw changes"
	)


func _test_t08_ricochet_direction() -> void:
	var result := _front_ricochet_case()
	var expected: Vector2 = result["reflected_direction_2d"]
	var projectile: V0Projectile = PROJECTILE_SCRIPT.new()
	root.add_child(projectile)
	projectile.direction_2d = result["projectile_direction_2d"]
	projectile.validation_apply_ricochet(result)
	var passed := (
		expected.length_squared() > 0.99
		and projectile.direction_2d.is_equal_approx(expected)
		and projectile.direction_2d.y < 0.0
		and projectile.ricochet_count == 1
	)
	_record(
		"V0-T08",
		passed,
		"armor reflection vector equals the projectile continuation vector"
	)
	projectile.queue_free()


func _test_t09_repeated_reset(test_range: V0TestRange) -> void:
	for index in range(3):
		test_range.fire_aphe()
		test_range.debug_overlay.last_report = {"result": "STALE"}
		test_range.camera_controller.switch_camera()
		test_range.reset_range()
		await process_frame
	var passed := (
		test_range.projectile_root.get_child_count() == 0
		and test_range.debug_overlay.last_report.is_empty()
		and (
			test_range.camera_controller.active_mode
			== V0CameraController.CameraMode.TOP_DOWN
		)
		and test_range.turret.current_world_aim_point.is_equal_approx(
			V0TurretAim.INITIAL_AIM_POINT
		)
	)
	_record(
		"V0-T09",
		passed,
		"three reset cycles clear projectiles, debug result, camera, and aim state"
	)


func _projection_roundtrip_is_accurate(
	turret: V0TurretAim,
	camera: Camera3D
) -> bool:
	var viewport_size := get_root().get_visible_rect().size
	var samples := [
		viewport_size * 0.5,
		Vector2(viewport_size.x * 0.15, viewport_size.y * 0.2),
		Vector2(viewport_size.x * 0.85, viewport_size.y * 0.8),
	]
	for sample in samples:
		var world_point: Variant = turret.compute_world_aim(sample, camera)
		if world_point == null:
			return false
		var projected := camera.unproject_position(world_point)
		if projected.distance_to(sample) > 0.5:
			return false
		if absf((world_point as Vector3).y) > 0.0001:
			return false
	return true


func _front_ricochet_case() -> Dictionary:
	return ArmorLogic2D.resolve_hit(
		Vector2.ZERO,
		0.0,
		Vector2(0.9848078, 0.1736482),
		Vector2(0.0, -2.0),
		90.0,
		55.0,
		35.0,
		120.0,
		75.0
	)


func _record(test_id: String, passed: bool, detail: String) -> void:
	_results[test_id] = "PASS" if passed else "FAIL"
	print("%s detail: %s" % [test_id, detail])
	if not passed:
		_failure_details.append("%s failed: %s" % [test_id, detail])
