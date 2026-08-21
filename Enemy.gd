extends KinematicBody2D

export(NodePath) var player_path

export var patrol_distance = 100
export var speed = 50
export var run_speed = 100

export var aggro_range = 200
export var attack_range = 70
export var attack_cooldown = 1.0

onready var player = get_node(player_path)
onready var sprite = $AnimatedSprite

var direction = 1
var attacking = false
var attack_timer = 0.0
var velocity = Vector2.ZERO
var starting_x = 0


func _ready():
	starting_x = global_position.x


func _physics_process(delta):

	# Cooldown
	if attack_timer > 0:
		attack_timer -= delta

	# Distance from knight to player
	var distance_to_player = global_position.distance_to(player.global_position)


	# =================================
	# PLAYER IS CLOSE - AGGRO
	# =================================

	if distance_to_player <= aggro_range:

		# Face the player
		if player.global_position.x < global_position.x:
			direction = -1
			sprite.flip_h = true
		else:
			direction = 1
			sprite.flip_h = false


		# Close enough to attack
		if distance_to_player <= attack_range:

			velocity = Vector2.ZERO

			if not attacking and attack_timer <= 0:
				attack()

		# Player is in aggro range but not attack range
		else:

			if not attacking:

				velocity.x = direction * run_speed
				sprite.play("Run")

				move_and_slide(velocity, Vector2.UP)


	# =================================
	# PLAYER IS FAR AWAY - PATROL
	# =================================

	else:

		if not attacking:

			velocity.x = direction * speed

			sprite.play("Walk")

			move_and_slide(velocity, Vector2.UP)


			# Right patrol limit
			if global_position.x >= starting_x + patrol_distance:
				direction = -1
				sprite.flip_h = true


			# Left patrol limit
			elif global_position.x <= starting_x - patrol_distance:
				direction = 1
				sprite.flip_h = false


func attack():

	attacking = true
	attack_timer = attack_cooldown

	velocity = Vector2.ZERO

	sprite.play("Attack")

	yield(sprite, "animation_finished")

	attacking = false
