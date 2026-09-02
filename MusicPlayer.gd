extends Node

onready var player = AudioStreamPlayer.new()

func _ready():
	add_child(player)
	player.bus = "Master"

func play_music(stream: AudioStream, volume_db := 0.0):
	# Avoid restarting the same track if it's already playing
	if player.stream == stream and player.playing:
		return
	player.stream = stream
	player.volume_db = volume_db
	player.play()

func stop_music():
	player.stop()
