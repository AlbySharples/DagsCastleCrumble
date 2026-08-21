extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const SPEED = 200
const JUMP_HEIGHT = -500

export(PackedScene) var rolling_pin_scene

var motion = Vector2()

# Shooting
var shoot_cooldown = 2.0
var shoot_timer = 0.0
var throwing = false


func _physics_process(delta):
	# Gravity
	motion.y += GRAVITY

	# Shooting cooldown
	if shoot_timer > 0:
		shoot_timer -= delta


	# MOVEMENT
	if Input.is_action_pressed("ui_right"):
		motion.x = SPEED
		$Sprite.flip_h = false

		if not throwing:
			$Sprite.play("Run")


	elif Input.is_action_pressed("ui_left"):
		motion.x = -SPEED
		$Sprite.flip_h = true

		if not throwing:
			$Sprite.play("Run")


	else:
		motion.x = 0

		if not throwing:
			$Sprite.play("Idle")


	# JUMP
	if is_on_floor():

		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT

			if not throwing:
				$Sprite.play("Jump")

	else:

		if motion.y < 0:

			if not throwing:
				$Sprite.play("Jump")

		else:

			if not throwing:
				$Sprite.play("Fall")


	# SHOOT
	if Input.is_action_just_pressed("shoot") and shoot_timer <= 0 and not throwing:
		shoot()


	motion = move_and_slide(motion, UP)


func shoot():

	# Start cooldown
	shoot_timer = shoot_cooldown

	# Stop movement while throwing
	motion.x = 0

	throwing = true

	# Play throw animation
	$Sprite.play("Throw")

	# Wait for the animation to finish
	yield($Sprite, "animation_finished")

	# Create rolling pin
	var rolling_pin = rolling_pin_scene.instance()

	get_parent().add_child(rolling_pin)

	# Put pin at Dag's position
	rolling_pin.global_position = $ThrowPoint.global_position

	# Send pin in the direction Dag is facing
	if $Sprite.flip_h:
		rolling_pin.direction = -1
	else:
		rolling_pin.direction = 1

	throwing = false
	
	
	
	
	
