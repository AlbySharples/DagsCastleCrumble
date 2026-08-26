extends KinematicBody2D

export var patrol_distance = 100
export var speed = 50
export var run_speed = 100

export var aggro_range = 200
export var attack_range = 70
export var attack_cooldown = 1.0

export var health = 3
export var tutorial_enemy = false

const GRAVITY = 20

onready var sprite = $AnimatedSprite

var player = null

var direction = 1
var attacking = false
var hurt = false
var dead = false
var tutorial_attack_done = false

var attack_timer = 0.0
var velocity = Vector2.ZERO
var starting_x = 0


func _ready():

	starting_x = global_position.x

	# Find Dag using the player group
	var players = get_tree().get_nodes_in_group("player")

	if players.size() > 0:
		player = players[0]

	# Tutorial enemy dies in one hit
	if tutorial_enemy:
		health = 1

	# Start patrol going right
	direction = 1
	sprite.flip_h = false


func _physics_process(delta):

	# Stop if Dag cannot be found
	if player == null:
		return

	# Don't run normal behaviour while hurt or dead
	if hurt or dead:
		velocity.x = 0
		move_and_slide(velocity, Vector2.UP)
		return

	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY
	else:
		velocity.y = 0

	# Attack cooldown
	if attack_timer > 0:
		attack_timer -= delta

	# Distance from enemy to player
	var distance_to_player = global_position.distance_to(player.global_position)


	# =================================
	# PLAYER IS CLOSE - AGGRO
	# =================================

	if distance_to_player <= aggro_range:

		# Face player
		if player.global_position.x < global_position.x:
			direction = -1
			sprite.flip_h = true
		else:
			direction = 1
			sprite.flip_h = false


		# Attack range
		if distance_to_player <= attack_range:

			velocity.x = 0

			if not attacking and attack_timer <= 0:
				attack()


		# Chase player
		else:

			if not attacking:

				velocity.x = direction * run_speed

				if sprite.animation != "Run":
					sprite.play("Run")


	# =================================
	# PLAYER IS FAR AWAY - PATROL
	# =================================

	else:

		if not attacking:

			velocity.x = direction * speed

			if sprite.animation != "Walk":
				sprite.play("Walk")

			# Right patrol limit
			if global_position.x >= starting_x + patrol_distance:

				direction = -1
				sprite.flip_h = true


			# Left patrol limit
			elif global_position.x <= starting_x - patrol_distance:

				direction = 1
				sprite.flip_h = false


	# Move enemy
	move_and_slide(velocity, Vector2.UP)


func attack():

	# Tutorial enemy can only attack once
	if tutorial_enemy and tutorial_attack_done:
		return

	attacking = true
	velocity.x = 0

	# Play attack animation
	sprite.play("Attack")

	# Wait for the Attack animation to completely finish
	yield(sprite, "animation_finished")

	# Don't continue if dead
	if dead:
		return

	# Check if Dag is still in range
	if global_position.distance_to(player.global_position) <= attack_range:

		player.take_damage()

		# Tutorial enemy only attacks once
		if tutorial_enemy:
			tutorial_attack_done = true

	# Start cooldown
	attack_timer = attack_cooldown

	# Stop attacking
	attacking = false

	# Return to Idle after the swing
	sprite.play("Idle")


func take_damage():

	if dead:
		return

	health -= 1


	# ================================
	# STILL ALIVE
	# ================================

	if health > 0:

		hurt = true
		attacking = false
		velocity = Vector2.ZERO

		sprite.play("Hurt")

		yield(sprite, "animation_finished")

		if dead:
			return

		hurt = false

		# Return to Idle after Hurt
		sprite.play("Idle")

		return


	# ================================
	# DEAD
	# ================================

	dead = true
	hurt = false
	attacking = false
	velocity = Vector2.ZERO

	sprite.play("Death")

	yield(sprite, "animation_finished")

	queue_free()
