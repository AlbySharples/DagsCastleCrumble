extends Node2D

export(PackedScene) var cannonball_scene

export var min_delay = 0.5
export var max_delay = 1.2

export var min_x = 100
export var max_x = 1700
export var spawn_y = -100


func _ready():

	randomize()
	
	spawn_cannonballs()
	


func spawn_cannonballs():

	while true:

		# Wait a random amount of time
		var delay = rand_range(min_delay, max_delay)

		yield(get_tree().create_timer(delay), "timeout")

		# Create cannonball
		var cannonball = cannonball_scene.instance()

		get_parent().add_child(cannonball)

		# Random horizontal position
		var random_x = rand_range(min_x, max_x)
		SfxPlayer.play(preload("res://SFX/Canonball.wav"), -15)
		cannonball.global_position = Vector2(
			random_x,
			spawn_y
			
			
		)
