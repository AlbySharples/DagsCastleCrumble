extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const SPEED = 200
const JUMP_HEIGHT = -550

export(PackedScene) var rolling_pin_scene

var motion = Vector2()

# Shooting
var shoot_cooldown = 1.0
var shoot_timer = 0.0
var throwing = false

# Tutorial controls
var tutorial_can_move = true
var tutorial_can_jump = true
var tutorial_can_shoot = true


func _physics_process(delta):

	# Gravity
	motion.y += GRAVITY

	# Shooting cooldown
	if shoot_timer > 0:
		shoot_timer -= delta

	# =================================
	# MOVEMENT
	# =================================

	if tutorial_can_move:

		if Input.is_key_pressed(KEY_D):
			motion.x = SPEED
			$Sprite.flip_h = false

			if not throwing:
				$Sprite.play("Run")

		elif Input.is_key_pressed(KEY_A):
			motion.x = -SPEED
			$Sprite.flip_h = true

			if not throwing:
				$Sprite.play("Run")

		else:
			motion.x = 0

			if not throwing:
				$Sprite.play("Idle")

	else:
		motion.x = 0

		if not throwing:
			$Sprite.play("Idle")

	# =================================
	# JUMP
	# =================================

	if tutorial_can_jump and is_on_floor():

		if Input.is_key_pressed(KEY_SPACE):
			motion.y = JUMP_HEIGHT

			if not throwing:
				$Sprite.play("Jump")

	# Jump/Fall animations only when jumping is unlocked
	if tutorial_can_jump and not is_on_floor():

		if motion.y < 0:

			if not throwing:
				$Sprite.play("Jump")

		else:

			if not throwing:
				$Sprite.play("Fall")

	# =================================
	# SHOOT
	# =================================

	if tutorial_can_shoot:

		if Input.is_action_just_pressed("shoot") and shoot_timer <= 0 and not throwing:
			shoot()

	# =================================
	# POTION
	# =================================

	if Input.is_action_just_pressed("use_potion"):
		if Global.use_potion():
			print("Potion used!")

	# Move
	motion = move_and_slide(motion, UP)

func shoot():

	shoot_timer = shoot_cooldown
	motion.x = 0
	throwing = true

	$Sprite.play("Throw")

	var rolling_pin = rolling_pin_scene.instance()
	get_parent().add_child(rolling_pin)

	# Put the pin at Dag
	rolling_pin.global_position = $ThrowPoint.global_position

	# Set direction based on Dag's facing
	if $Sprite.flip_h:
		rolling_pin.global_position = $ThrowPoint.global_position
		rolling_pin.direction = -1
	else:
		rolling_pin.global_position = $ThrowPoint.global_position
		rolling_pin.direction = 1

	yield($Sprite, "animation_finished")

	throwing = false

func take_damage():

	Global.lose_life()

	if Global.lives <= 0:
		print("Game Over")
