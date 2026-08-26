extends Node

onready var dag = get_parent().get_node("Player")
onready var tutorial_text = $CanvasLayer/TutorialText
onready var enemy = get_parent().get_node("Enemy")

var step = 0
var move_timer = 0.0
var potion_amount_before = 0


func _ready():

	# Start with everything locked
	dag.tutorial_can_move = false
	dag.tutorial_can_jump = false
	dag.tutorial_can_shoot = false

	tutorial_text.text = "WELCOME TO THE CASTLE!\n\nUse A and D to move."


func _process(delta):

	# =================================
	# STEP 0 - MOVEMENT
	# =================================

	if step == 0:

		if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_D):

			dag.tutorial_can_move = true

			move_timer = 0.0
			step = 1

			tutorial_text.text = ""


	# =================================
	# STEP 1 - LET PLAYER MOVE
	# =================================

	elif step == 1:

		move_timer += delta

		if move_timer >= 3.0:

			dag.tutorial_can_move = false
			dag.tutorial_can_jump = true

			step = 2

			tutorial_text.text = "PRESS SPACE TO JUMP"


	# =================================
	# STEP 2 - JUMP
	# =================================

	elif step == 2:

		if Input.is_key_pressed(KEY_SPACE):

			dag.tutorial_can_move = true
			dag.tutorial_can_jump = true

			step = 3

			tutorial_text.text = "GREAT JOB!\n\nKeep walking forward to the gate."


	# =================================
	# STEP 3 - WALK TOWARD ENEMY
	# =================================

	elif step == 3:

		if not is_instance_valid(enemy):
			return

		var distance_to_enemy = dag.global_position.distance_to(
			enemy.global_position
		)

		if distance_to_enemy <= 150:

			dag.tutorial_can_move = false
			dag.tutorial_can_jump = false
			dag.tutorial_can_shoot = false

			step = 4

			tutorial_text.text = "CAREFUL!\n\nGetting too close to an enemy will cause it to attack."


	# =================================
	# STEP 4 - WAIT FOR GUARD TO HIT
	# =================================

	elif step == 4:

		if Global.lives < 3:

			dag.tutorial_can_move = false
			dag.tutorial_can_jump = false
			dag.tutorial_can_shoot = false

			potion_amount_before = Global.potions

			step = 5

			tutorial_text.text = "YOU'VE BEEN HIT!\n\nPress R to use a potion."


	# =================================
	# STEP 5 - USE POTION
	# =================================

	elif step == 5:

		# Detect that one potion was actually consumed
		if Global.potions < potion_amount_before:

			dag.tutorial_can_move = false
			dag.tutorial_can_jump = false
			dag.tutorial_can_shoot = false

			step = 6

			tutorial_text.text = "CLICK TO THROW YOUR ROLLING PIN."


	# =================================
	# STEP 6 - WAIT FOR CLICK
	# =================================

	elif step == 6:

		if Input.is_action_just_pressed("shoot"):

			dag.tutorial_can_move = false
			dag.tutorial_can_jump = false
			dag.tutorial_can_shoot = true

			step = 7

			tutorial_text.text = "DEFEAT THE GUARD!"


	# =================================
	# STEP 7 - WAIT FOR GUARD TO DIE
	# =================================

	elif step == 7:

		if not is_instance_valid(enemy):

			dag.tutorial_can_move = true
			dag.tutorial_can_jump = true
			dag.tutorial_can_shoot = true

			tutorial_text.text = "GUARD DEFEATED!\n\nKeep going!"

			step = 8
