class_name V0DebugOverlay
extends Node

@export var player_path: NodePath
@export var turret_path: NodePath
@export var camera_controller_path: NodePath
@export var aim_marker_path: NodePath

@onready var player: V0PlayerTank = get_node(player_path)
@onready var turret: V0TurretAim = get_node(turret_path)
@onready var camera_controller: V0CameraController = get_node(camera_controller_path)
@onready var aim_marker: MeshInstance3D = get_node(aim_marker_path)
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var label: Label = $CanvasLayer/PanelContainer/MarginContainer/Label
@onready var world_lines: MeshInstance3D = $WorldLines

var enabled := true
var last_report: Dictionary = {}
var _immediate_mesh := ImmediateMesh.new()


func _ready() -> void:
	world_lines.mesh = _immediate_mesh
	var line_material := StandardMaterial3D.new()
	line_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	line_material.vertex_color_use_as_albedo = true
	line_material.no_depth_test = true
	world_lines.material_override = line_material
	_apply_visibility()


func _process(_delta: float) -> void:
	if not enabled:
		return
	label.text = _compose_text()
	aim_marker.global_position = turret.current_world_aim_point + Vector3.UP * 0.08


func toggle() -> void:
	enabled = not enabled
	_apply_visibility()


func _apply_visibility() -> void:
	canvas_layer.visible = enabled
	world_lines.visible = enabled
	aim_marker.visible = enabled


func report_hit(report: Dictionary) -> void:
	last_report = report.duplicate(true)
	_rebuild_world_lines()


func reset_state() -> void:
	last_report.clear()
	_immediate_mesh.clear_surfaces()
	aim_marker.global_position = turret.current_world_aim_point + Vector3.UP * 0.08


func _compose_text() -> String:
	var lines := PackedStringArray([
		"RICHOCHETANGLES — GODOT V0 FEASIBILITY RANGE",
		"W/S move  A/D turn  Mouse aim  LMB APHE  C camera  F1 debug  R reset",
		"",
		"camera: %s  switch_hold: %s" % [
			camera_controller.get_mode_name(),
			str(turret.waiting_for_mouse_after_switch),
		],
		"mouse px: %s" % _vector2_text(turret.mouse_screen_position),
		"world aim: %s" % _vector3_text(turret.current_world_aim_point),
		"stored aim: %s" % _vector3_text(turret.stored_world_aim_point),
		"player: %s  hull yaw: %.1f°  turret yaw: %.1f°" % [
			_vector3_text(player.global_position),
			rad_to_deg(player.global_rotation.y),
			rad_to_deg(turret.global_rotation.y),
		],
		"forward speed: %.2f m/s  actual speed: %.2f m/s" % [
			player.forward_speed,
			player.actual_speed,
		],
	])
	if last_report.is_empty():
		lines.append("")
		lines.append("last impact: none")
		return "\n".join(lines)

	lines.append_array(PackedStringArray([
		"",
		"projectile: %s  target: %s" % [
			str(last_report.get("projectile_id", "-")),
			str(last_report.get("target_id", "-")),
		],
		"target pos: %s  yaw: %.1f°" % [
			_vector2_text(last_report.get("target_position_2d", Vector2.ZERO)),
			rad_to_deg(float(last_report.get("target_yaw_radians", 0.0))),
		],
		"projectile dir 2D: %s" % _vector2_text(
			last_report.get("projectile_direction_2d", Vector2.ZERO)
		),
		"physics hit point 3D: %s" % _vector3_text(
			last_report.get("physics_hit_point_3d", Vector3.ZERO)
		),
		"physics hit normal 3D: %s" % _vector3_text(
			last_report.get("physics_hit_normal_3d", Vector3.ZERO)
		),
		"logical armor normal 2D: %s" % _vector2_text(
			last_report.get("logical_armor_normal_2d", Vector2.ZERO)
		),
		"zone: %s  incidence: %.2f°" % [
			str(last_report.get("armor_zone", "-")),
			float(last_report.get("incidence_angle_degrees", 0.0)),
		],
		"armor: %.1f mm  effective: %.1f mm  penetration: %.1f mm" % [
			float(last_report.get("base_armor_mm", 0.0)),
			float(last_report.get("effective_armor_mm", 0.0)),
			float(last_report.get("penetration_mm", 0.0)),
		],
		"result: %s" % str(last_report.get("result", "-")),
		"reason: %s" % str(last_report.get("reason", "-")),
		"reflected dir 2D: %s" % _vector2_text(
			last_report.get("reflected_direction_2d", Vector2.ZERO)
		),
	]))
	return "\n".join(lines)


func _rebuild_world_lines() -> void:
	_immediate_mesh.clear_surfaces()
	if last_report.is_empty() or not last_report.has("physics_hit_point_3d"):
		return
	var hit_point: Vector3 = last_report["physics_hit_point_3d"]
	var incoming_2d: Vector2 = last_report.get("projectile_direction_2d", Vector2.ZERO)
	var physics_normal: Vector3 = last_report.get("physics_hit_normal_3d", Vector3.ZERO)
	var logical_2d: Vector2 = last_report.get("logical_armor_normal_2d", Vector2.ZERO)
	var reflected_2d: Vector2 = last_report.get("reflected_direction_2d", Vector2.ZERO)

	_immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	_add_line(
		hit_point - Vector3(incoming_2d.x, 0.0, incoming_2d.y) * 4.0,
		hit_point,
		Color(1.0, 0.75, 0.15)
	)
	_add_line(hit_point, hit_point + physics_normal * 3.0, Color(0.2, 0.8, 1.0))
	_add_line(
		hit_point,
		hit_point + Vector3(logical_2d.x, 0.0, logical_2d.y) * 3.0,
		Color(0.25, 1.0, 0.35)
	)
	if reflected_2d.length_squared() > 0.0:
		_add_line(
			hit_point,
			hit_point + Vector3(reflected_2d.x, 0.0, reflected_2d.y) * 4.0,
			Color(1.0, 0.25, 0.8)
		)
	_immediate_mesh.surface_end()


func _add_line(start: Vector3, finish: Vector3, color: Color) -> void:
	_immediate_mesh.surface_set_color(color)
	_immediate_mesh.surface_add_vertex(start + Vector3.UP * 0.12)
	_immediate_mesh.surface_set_color(color)
	_immediate_mesh.surface_add_vertex(finish + Vector3.UP * 0.12)


func _vector2_text(value: Vector2) -> String:
	return "(%.2f, %.2f)" % [value.x, value.y]


func _vector3_text(value: Vector3) -> String:
	return "(%.2f, %.2f, %.2f)" % [value.x, value.y, value.z]
