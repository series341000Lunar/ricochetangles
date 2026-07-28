class_name ArmorLogic2D
extends RefCounted

const RESULT_RICOCHET := "RICOCHET"
const RESULT_NON_PENETRATION := "NON_PENETRATION"
const RESULT_PENETRATION := "PENETRATION"
const REASON_AUTO_RICOCHET := "AUTO_RICOCHET_ANGLE"
const REASON_ARMOR_STOPPED := "EFFECTIVE_ARMOR_EXCEEDS_PENETRATION"
const REASON_PENETRATED := "PENETRATION_MEETS_EFFECTIVE_ARMOR"
const MIN_EFFECTIVE_COSINE := 0.05
const DIRECTION_EPSILON_SQUARED := 0.000001


static func resolve_hit(
	target_position_2d: Vector2,
	target_yaw: float,
	projectile_direction_2d: Vector2,
	hit_point_2d: Vector2,
	front_armor_mm: float,
	side_armor_mm: float,
	rear_armor_mm: float,
	penetration_mm: float,
	auto_ricochet_degrees: float
) -> Dictionary:
	var projectile_direction := projectile_direction_2d.normalized()
	if projectile_direction.length_squared() < DIRECTION_EPSILON_SQUARED:
		push_error("ArmorLogic2D requires a non-zero projectile direction.")
		return {}

	var forward := Vector2(-sin(target_yaw), -cos(target_yaw)).normalized()
	var right := Vector2(cos(target_yaw), -sin(target_yaw)).normalized()
	var relative_hit := hit_point_2d - target_position_2d
	if relative_hit.length_squared() < DIRECTION_EPSILON_SQUARED:
		relative_hit = -projectile_direction

	var forward_amount := relative_hit.dot(forward)
	var right_amount := relative_hit.dot(right)
	var zone := "SIDE"
	var logical_normal := right if right_amount >= 0.0 else -right
	var base_armor_mm := side_armor_mm

	# Exact diagonal ties belong to FRONT/REAR. This keeps the boundary deterministic.
	if absf(forward_amount) >= absf(right_amount):
		if forward_amount >= 0.0:
			zone = "FRONT"
			logical_normal = forward
			base_armor_mm = front_armor_mm
		else:
			zone = "REAR"
			logical_normal = -forward
			base_armor_mm = rear_armor_mm

	var incidence_cosine := clampf((-projectile_direction).dot(logical_normal), 0.0, 1.0)
	var incidence_angle_degrees := rad_to_deg(acos(incidence_cosine))
	var stabilized_cosine := maxf(incidence_cosine, MIN_EFFECTIVE_COSINE)
	var effective_armor_mm := base_armor_mm / stabilized_cosine
	var result := RESULT_NON_PENETRATION
	var reason := REASON_ARMOR_STOPPED
	var reflected_direction := Vector2.ZERO

	if incidence_angle_degrees >= auto_ricochet_degrees:
		result = RESULT_RICOCHET
		reason = REASON_AUTO_RICOCHET
		reflected_direction = (
			projectile_direction
			- 2.0 * projectile_direction.dot(logical_normal) * logical_normal
		).normalized()
	elif penetration_mm >= effective_armor_mm:
		result = RESULT_PENETRATION
		reason = REASON_PENETRATED

	return {
		"armor_zone": zone,
		"logical_armor_normal_2d": logical_normal,
		"incidence_angle_degrees": incidence_angle_degrees,
		"base_armor_mm": base_armor_mm,
		"effective_armor_mm": effective_armor_mm,
		"penetration_mm": penetration_mm,
		"result": result,
		"reason": reason,
		"reflected_direction_2d": reflected_direction,
		"projectile_direction_2d": projectile_direction,
		"target_position_2d": target_position_2d,
		"target_yaw_radians": target_yaw,
	}
