extends CharacterBody3D
class_name Player

@export var speed = 6.5
@export var acceleration = 2.0

@export var mouse_sensitivity = 0.003
@export var rotation_speed = 12.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var spring_arm = $SpringArm3D
@onready var model = $Rig_Large
@onready var animation_tree = $AnimationTree
@onready var animation_state = $AnimationTree.get("parameters/playback")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	velocity.y += -gravity * delta
	
	get_move_input(delta)

	move_and_slide()
	
	var horizontal_velocity = Vector3(velocity.x, 0.0, velocity.z)

	if horizontal_velocity.length() > 0.1:
		var target_rotation = atan2(-horizontal_velocity.x, -horizontal_velocity.z)
		
		model.rotation.y = lerp_angle(
			model.rotation.y,
			target_rotation,
			rotation_speed * delta
		)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		spring_arm.rotation.x -= event.relative.y * mouse_sensitivity
		spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -90.0, 30.0)
		spring_arm.rotation.y -= event.relative.x * mouse_sensitivity
		
func get_move_input(delta):
	var vy = velocity.y
	velocity.y = 0
	
	var input = Input.get_vector("left", "right", "forwards", "backwards")
	var direction = Vector3(input.x, 0, input.y).rotated(Vector3.UP, spring_arm.rotation.y)
	
	velocity = lerp(velocity, direction * speed, acceleration * delta)
	velocity.y = vy

	var vl = velocity * model.transform.basis
	animation_tree.set("parameters/Idle-Walk-Run-Cycle/blend_position", Vector2(vl.x, -vl.z) / speed)
