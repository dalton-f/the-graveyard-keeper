extends Interactable

@onready var fence_broken: MeshInstance3D = $FenceBroken
@onready var fence: MeshInstance3D = $Fence
@onready var sprite_3d: Sprite3D = $Sprite3D

@export var repair_fence_audio: AudioStream

func _ready():
	enabled = false
	
	# There is a 1 in 3 chance for the fence to be the broken variant
	if randi_range(1, 3) == 1:
		fence.visible = false
		fence_broken.visible = true
		sprite_3d.visible = true
		
		enabled = true

func _on_interacted(_body: Variant) -> void:
	enabled = false
	
	fence.visible = true
	fence_broken.visible = false
	
	sprite_3d.visible = false
	
	AudioManager.play_sfx(repair_fence_audio)
