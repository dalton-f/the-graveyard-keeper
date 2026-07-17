extends CharacterBody3D
class_name Player

@export_category("Movement")
@export var speed: float = 6.5
@export var acceleration: float = 5.0

@export_category("Camera")
@export var mouse_sensitivity: float = 0.003
@export var camera_min_pitch: float = -90.0
@export var camera_max_pitch: float = 30.0

@export_category("Rotation")
@export var rotation_speed: float = 12.0

var animation_blend := Vector2.ZERO

var gravity: float = ProjectSettings.get_setting(
	"physics/3d/default_gravity"
)

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var model: Node3D = $Rig_Large
@onready var animation_tree: AnimationTree = $AnimationTree

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement(delta)
	handle_rotation(delta)
	
	update_animation(delta)

	move_and_slide()
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		spring_arm.rotation.x -= event.relative.y * mouse_sensitivity
		spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -90.0, 30.0)
		spring_arm.rotation.y -= event.relative.x * mouse_sensitivity

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

func handle_movement(delta: float) -> void:
	var input_direction  = Input.get_vector("left", "right", "forwards", "backwards")
	# Make movement relative to camera
	var move_direction = Vector3(input_direction.x, 0, input_direction.y).rotated(Vector3.UP, spring_arm.rotation.y)
	
	velocity = lerp(velocity, move_direction * speed, acceleration * delta)

func handle_rotation(delta: float) -> void:
	var horizontal_velocity = Vector3(velocity.x, 0.0, velocity.z)
	
	if horizontal_velocity.length() < 0.1:
		return

	var target_rotation = atan2(-horizontal_velocity.x, -horizontal_velocity.z)
		
	model.rotation.y = lerp_angle(
		model.rotation.y,
		target_rotation,
		rotation_speed * delta
	)
	
func update_animation(delta: float) -> void:
	var local_velocity := (velocity * model.transform.basis)
	
	var target_blend_position := Vector2(local_velocity.x, -local_velocity.z) / speed
	
	# Smooth the blend position to stop snapping from movement to idle
	animation_blend = animation_blend.lerp(target_blend_position, 8.0 * delta)
	
	animation_tree.set("parameters/Idle-Walk-Run-Cycle/blend_position", animation_blend)
