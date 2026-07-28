class_name V0TestRange
extends Node3D

const PROJECTILE_SCENE := preload("res://scenes/projectile.tscn")

@onready var player: V0PlayerTank = $PlayerTank
@onready var turret: V0TurretAim = $PlayerTank/TurretPivot
@onready var camera_controller: V0CameraController = $CameraRig
@onready var projectile_root: Node3D = $ProjectileRoot
@onready var debug_overlay: V0DebugOverlay = $DebugOverlay

var _next_projectile_id := 1


func _ready() -> void:
	turret.set_camera_controller(camera_controller)
	reset_range()


func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			fire_aphe()
	elif event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_R:
				reset_range()
			KEY_F1:
				debug_overlay.toggle()


func fire_aphe() -> V0Projectile:
	var muzzle_transform := turret.get_muzzle_transform()
	var projectile: V0Projectile = PROJECTILE_SCENE.instantiate()
	projectile.impact.connect(_on_projectile_impact)
	projectile_root.add_child(projectile)
	projectile.initialize(
		_next_projectile_id,
		muzzle_transform.origin,
		-muzzle_transform.basis.z
	)
	_next_projectile_id += 1
	return projectile


func _on_projectile_impact(report: Dictionary) -> void:
	debug_overlay.report_hit(report)


func reset_range() -> void:
	for projectile in projectile_root.get_children():
		projectile.queue_free()
	player.reset_state()
	for target in get_tree().get_nodes_in_group("v0_targets"):
		target.reset_state()
	camera_controller.reset_state()
	debug_overlay.reset_state()
	_next_projectile_id = 1
