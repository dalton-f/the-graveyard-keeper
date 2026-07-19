extends Area3D

@onready var prompt: Label = $Prompt

var current_interactable: Interactable = null

func _physics_process(_delta):
	if current_interactable:
		# Check input every frame
		if Input.is_action_just_pressed(current_interactable.prompt_action):
			current_interactable.interact(owner)
	else:
		prompt.text = ""

func _on_body_entered(body: Node3D) -> void:
	if body is Interactable:
		current_interactable = body
		
		prompt.text = current_interactable.get_prompt()

func _on_body_exited(body: Node3D) -> void:
	if body == current_interactable:
		current_interactable = null
