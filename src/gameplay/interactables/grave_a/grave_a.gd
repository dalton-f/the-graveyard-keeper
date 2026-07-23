extends Interactable

@onready var grave_a_destroyed: MeshInstance3D = $GraveADestroyed
@onready var grave_a: MeshInstance3D = $GraveA
@onready var sprite_3d: Sprite3D = $Sprite3D

func _ready():
	enabled = false
	
	# There is a 2 in 5 chance for the fence to be the broken variant
	if randi_range(1, 5) == 3 or randi_range(1, 5) == 2:
		grave_a.visible = false
		grave_a_destroyed.visible = true
		sprite_3d.visible = true
				
		enabled = true

func _on_interacted(_body: Variant) -> void:
	enabled = false
	
	grave_a.visible = true
	grave_a_destroyed.visible = false
	sprite_3d.visible = false
