extends KinematicBody2D

export(PackedScene) var arrow_scene

export var aggro_range = 1000
export var shoot_cooldown = 2.0
export var health = 3

const GRAVITY = 20

onready var sprite = $AnimatedSprite
onready var arrow_point = $ArrowPoint

var player = null
var velocity = Vector2.ZERO

var shooting = false
var hurt = false
var dead = false


func _ready():

	var players = get_tree().get_nodes_in_group("player")

	if players.size() > 0:
		player = players[0]

	start_shooting()


func _physics_process(delta):

	if dead:
		return

	if player == null:
		return

	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY
	else:
		velocity.y = 0

	# Don't interrupt animations
	if shooting or hurt:
		velocity.x = 0
		move_and_slide(velocity, Vector2.UP)
		return

	# Face Dag
	if player.global_position.x < global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

	sprite.play("Idle")

	move_and_slide(velocity, Vector2.UP)


func start_shooting():

	while not dead:

		# Wait 2 seconds before the next shot
		yield(get_tree().create_timer(shoot_cooldown), "timeout")

		if dead:
			return

		shoot()


func shoot():

	if shooting or dead:
		return

	shooting = true
	velocity.x = 0

	# Face Dag
	if player.global_position.x < global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

	# Play the full shoot animation
	sprite.play("Shoot")
	

# Wait until 0.1 seconds before the animation finishes
	var shoot_length = sprite.frames.get_frame_count("Shoot") / sprite.frames.get_animation_speed("Shoot")
	
	yield(get_tree().create_timer(shoot_length - 0.3), "timeout")
	SfxPlayer.play(preload("res://SFX/Bow.ogg"))

	var arrow = arrow_scene.instance()

	get_parent().add_child(arrow)

	arrow.global_position = arrow_point.global_position

	# Fire toward Dag
	if sprite.flip_h:
		arrow.direction = -1
	else:
		arrow.direction = 1

	shooting = false


func take_damage():

	if dead:
		return

	health -= 1

	# =================================
	# STILL ALIVE
	# =================================

	if health > 0:

		hurt = true
		shooting = false
		velocity = Vector2.ZERO

		sprite.play("Hurt")

		# Give the Hurt animation time to play
		yield(get_tree().create_timer(0.5), "timeout")

		if dead:
			return

		hurt = false

		return


	# =================================
	# DEAD
	# =================================

	dead = true
	hurt = false
	shooting = false
	velocity = Vector2.ZERO

	sprite.play("Death")

	yield(sprite, "animation_finished")

	queue_free()
