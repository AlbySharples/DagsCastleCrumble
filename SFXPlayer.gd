extends Node

func play(stream: AudioStream, volume_db := 0.0):
	# Spawn a one-shot audio player, play the given sound, then clean itself up when done
	var sfx = AudioStreamPlayer.new()
	sfx.stream = stream
	sfx.volume_db = volume_db
	sfx.bus = "Master"
	add_child(sfx)
	sfx.play()
	sfx.connect("finished", sfx, "queue_free")
