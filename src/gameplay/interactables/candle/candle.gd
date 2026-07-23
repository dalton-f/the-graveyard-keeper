extends Interactable

@onready var candle_melted: MeshInstance3D = $CandleMelted
@onready var candle: MeshInstance3D = $Candle
@onready var sprite_3d: Sprite3D = $Sprite3D

@export var replace_candle_audio: AudioStream

func _ready():
	enabled = false
	
	# There is a 1 in 3 chance for the fence to be the broken variant
	if randi_range(1, 3) == 1:
		candle.visible = false
		candle_melted.visible = true
		sprite_3d.visible = true
		
		enabled = true

func _on_interacted(_body: Variant) -> void:
	enabled = false
	
	candle.visible = true
	candle_melted.visible = false
	sprite_3d.visible = false
	
	AudioManager.play_sfx(replace_candle_audio)
