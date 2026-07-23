extends Area3D

@onready var prompt: Label = $MarginContainer/Prompt

var interactables: Array[Interactable] = []
var current_interactable: Interactable = null

func _physics_process(_delta):
	interactables = interactables.filter(
		func(interactable): return interactable.enabled
	)
	
	current_interactable = interactables[0] if interactables.size() > 0 else null
	
	if current_interactable:
		prompt.text = current_interactable.get_prompt()
		
		# Check input every frame
		if Input.is_action_just_pressed(current_interactable.prompt_action):
			current_interactable.interact(owner)
	else:
		prompt.text = ""

func _on_body_entered(body: Node3D) -> void:
	if body is Interactable and not interactables.has(body) and body.enabled:
		interactables.append(body)

func _on_body_exited(body: Node3D) -> void:
	if body is Interactable:
		interactables.erase(body)
		
