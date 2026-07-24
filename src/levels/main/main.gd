extends Node3D

@export var graveyard_ambiance: AudioStream

func _ready():
	AudioManager.play_music(graveyard_ambiance)
