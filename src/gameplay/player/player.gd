extends CharacterBody3D
class_name Player

@export var speed = 5.0
@export var acceleration = 4.0
@export var jump_speed = 8.0
@export var mouse_sensitivity = 0.0015
@export var rotation_speed = 12.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var spring_arm = $SpringArm3D
@onready var model = $Rig_Large
@onready var animation_tree = $AnimationTree
@onready var animation_state = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	velocity.y += -gravity * delta
	
	get_move_input(delta)

	move_and_slide()
	
	if velocity.length() > 1.0:
		model.rotation.y = lerp_angle(model.rotation.y, spring_arm.rotation.y, rotation_speed * delta)
	
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
	animation_tree.set("parameters/IWR/blend_position", Vector2(vl.x, -vl.z) / speed)
