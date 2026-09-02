extends Node2D

export(PackedScene) var barrel_scene   # The barrel scene to spawn

func _ready():
	$SpawnTimer.start()   # Start the repeating spawn timer

func _on_SpawnTimer_timeout():
	# Spawn a new barrel at this spawner's position each time the timer fires
	var barrel = barrel_scene.instance()
	get_parent().add_child(barrel)
	barrel.global_position = global_position
