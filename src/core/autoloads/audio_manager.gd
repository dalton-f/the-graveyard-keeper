extends Node

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

var music_volume: float = 0.1
var sfx_volume: float = 1.5

func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)

	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "SFX"
	add_child(sfx_player)

func play_music(track: AudioStream, loop: bool = true):
	music_player.stream = track
	track.loop = loop
	music_player.volume_db = linear_to_db(music_volume)
	
	music_player.play()

func play_sfx(effect: AudioStream):
	sfx_player.stream = effect
	sfx_player.volume_db = linear_to_db(sfx_volume)
	
	sfx_player.play()
