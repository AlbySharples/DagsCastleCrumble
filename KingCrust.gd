extends KinematicBody2D

# =================================
# BOSS SETTINGS
# =================================

export var speed = 100
export var attack_distance = 120
export var attack_stop_distance = 120
export var attack_cooldown = 2.0
export var health = 15
export var hit_validation_range = 180


# =================================
# VARIABLES
# =================================

var player
var velocity = Vector2.ZERO

var attacking = false
var has_attacked = false
var player_hit_this_attack = false

var current_attack_index = 0
var attack_queued = false

var direction = 1
var attack_timer = 0.0

var dead = false
var hurt = false
var hits_taken = 0
var fight_started = false


# =================================
# READY
# =================================

func _ready():

	$AnimatedSprite.play("Idle")

	$Attack1Hitbox.monitoring = false
	$Attack2Hitbox.monitoring = false
	$Attack3Hitbox.monitoring = false

	var players = get_tree().get_nodes_in_group("player")

	if players.size() > 0:

		player = players[0]

		# Boss scene only
		player.current_jump_height = -800
		player.current_speed = 250

	set_facing(1)


# =================================
# PHYSICS
# =================================

func _physics_process(delta):

	if player == null:
		return


	# Fight hasn't started
	if not fight_started:

		velocity.x = 0
		move_and_slide(velocity, Vector2.UP)

		return


	# Dead / hurt
	if hurt or dead:

		velocity.x = 0
		move_and_slide(velocity, Vector2.UP)

		return


	# Attack cooldown
	if attack_timer > 0:

		attack_timer -= delta


	# Currently attacking
	if attacking:

		velocity.x = 0
		move_and_slide(velocity, Vector2.UP)

		return


	# Waiting before attack
	if attack_queued:

		velocity.x = 0
		move_and_slide(velocity, Vector2.UP)

		return


	# Waiting after attack
	if has_attacked:

		velocity.x = 0
		move_and_slide(velocity, Vector2.UP)

		if $AnimatedSprite.animation != "Idle":
			$AnimatedSprite.play("Idle")

		if attack_timer <= 0:

			has_attacked = false

		return


	# =================================
	# DISTANCE TO DAG
	# =================================

	var player_x = player.global_position.x
	var king_x = global_position.x

	var x_distance = abs(player_x - king_x)


	# =================================
	# FACE DAG
	# =================================

	if player_x < king_x:

		set_facing(-1)

	else:

		set_facing(1)


	# =================================
	# DAG IS ABOVE
	# =================================

	var dag_is_above = player.global_position.y < global_position.y - 30

	if dag_is_above and x_distance <= 140:

		velocity.x = 0
		attack3()

		return


	# =================================
	# ATTACK RANGE
	# =================================

	if x_distance <= attack_stop_distance:

		velocity.x = 0
		do_next_attack()

		return


	# =================================
	# CHASE DAG
	# =================================

	if player_x < king_x:

		velocity.x = -speed

	else:

		velocity.x = speed


	move_and_slide(velocity, Vector2.UP)

	$AnimatedSprite.play("Run")


# =================================
# FACE DAG
# =================================

func set_facing(new_direction):

	direction = new_direction

	if direction == 1:

		$AnimatedSprite.flip_h = false

		$Attack1Hitbox.scale.x = 1
		$Attack2Hitbox.scale.x = 1
		$Attack3Hitbox.scale.x = 1

	else:

		$AnimatedSprite.flip_h = true

		$Attack1Hitbox.scale.x = -1
		$Attack2Hitbox.scale.x = -1
		$Attack3Hitbox.scale.x = -1


# =================================
# ATTACK 1
# =================================

func attack1():

	if attacking or has_attacked:
		return

	attacking = true
	velocity.x = 0
	player_hit_this_attack = false

	$AnimatedSprite.play("Attack1")

	SfxPlayer.play(preload("res://SFX/Slash.ogg"))

	yield(get_tree().create_timer(0.2), "timeout")

	if dead or hurt:

		$Attack1Hitbox.monitoring = false
		attacking = false

		return

	$Attack1Hitbox.monitoring = true

	for body in $Attack1Hitbox.get_overlapping_bodies():

		if body.name == "Player" and not player_hit_this_attack:

			player_hit_this_attack = true
			Global.lose_life()


	yield(get_tree().create_timer(0.2), "timeout")

	$Attack1Hitbox.monitoring = false

	if dead or hurt:

		attacking = false
		return

	yield(get_tree().create_timer(0.2), "timeout")

	attacking = false
	has_attacked = true
	attack_timer = attack_cooldown

	if not dead and not hurt:
		$AnimatedSprite.play("Idle")


# =================================
# ATTACK 2
# =================================

func attack2():

	if attacking or has_attacked:
		return

	attacking = true
	velocity.x = 0
	player_hit_this_attack = false

	$AnimatedSprite.play("Attack2")

	SfxPlayer.play(preload("res://SFX/Slash.ogg"))

	yield(get_tree().create_timer(0.2), "timeout")

	if dead or hurt:

		$Attack2Hitbox.monitoring = false
		attacking = false

		return

	$Attack2Hitbox.monitoring = true

	for body in $Attack2Hitbox.get_overlapping_bodies():

		if body.name == "Player" and not player_hit_this_attack:

			player_hit_this_attack = true
			Global.lose_life()


	yield(get_tree().create_timer(0.2), "timeout")

	$Attack2Hitbox.monitoring = false

	if dead or hurt:

		attacking = false
		return

	yield(get_tree().create_timer(0.2), "timeout")

	attacking = false
	has_attacked = true
	attack_timer = attack_cooldown

	if not dead and not hurt:
		$AnimatedSprite.play("Idle")


# =================================
# ATTACK 3
# =================================

func attack3():

	if attacking or has_attacked:
		return

	attacking = true
	velocity.x = 0
	player_hit_this_attack = false

	$AnimatedSprite.play("Attack3")

	SfxPlayer.play(preload("res://SFX/Slash.ogg"))

	yield(get_tree().create_timer(0.2), "timeout")

	if dead or hurt:

		$Attack3Hitbox.monitoring = false
		attacking = false

		return

	$Attack3Hitbox.monitoring = true

	for body in $Attack3Hitbox.get_overlapping_bodies():

		if body.name == "Player" and not player_hit_this_attack:

			player_hit_this_attack = true
			Global.lose_life()


	yield(get_tree().create_timer(0.2), "timeout")

	$Attack3Hitbox.monitoring = false

	if dead or hurt:

		attacking = false
		return

	yield(get_tree().create_timer(0.2), "timeout")

	attacking = false
	has_attacked = true
	attack_timer = attack_cooldown

	if not dead and not hurt:
		$AnimatedSprite.play("Idle")


# =================================
# NEXT ATTACK
# =================================

func do_next_attack():

	if attacking or has_attacked or attack_queued:
		return

	attack_queued = true

	velocity.x = 0

	$AnimatedSprite.play("Idle")

	yield(get_tree().create_timer(0.5), "timeout")

	if dead or hurt:

		attack_queued = false
		return


	match current_attack_index:

		0:
			attack1()

		1:
			attack2()

		2:
			attack3()


	current_attack_index = (current_attack_index + 1) % 3

	attack_queued = false
	
	

func _on_Attack1Hitbox_body_entered(body):

	if not attacking:
		return

	if player_hit_this_attack:
		return

	if body == player:

		player_hit_this_attack = true
		Global.lose_life()
		
func _on_Attack2Hitbox_body_entered(body):

	if not attacking:
		return

	if player_hit_this_attack:
		return

	if body == player:

		player_hit_this_attack = true
		Global.lose_life()
		
func _on_Attack3Hitbox_body_entered(body):

	if not attacking:
		return

	if player_hit_this_attack:
		return

	if body == player:

		player_hit_this_attack = true
		Global.lose_life()


# =================================
# TAKE DAMAGE
# =================================

const GoldenPieScene = preload("res://GoldenPie.tscn")


func take_damage():

	SfxPlayer.play(preload("res://SFX/playerhit.mp3"))

	if dead:
		return

	health -= 1
	hits_taken += 1


	if health > 0:

		if hits_taken % 5 == 0:

			hurt = true
			attacking = false
			attack_queued = false

			velocity = Vector2.ZERO

			$Attack1Hitbox.monitoring = false
			$Attack2Hitbox.monitoring = false
			$Attack3Hitbox.monitoring = false

			$AnimatedSprite.play("TakeHit")

			yield($AnimatedSprite, "animation_finished")

			if dead:
				return

			hurt = false

			$AnimatedSprite.play("Idle")

		return


	# =================================
	# DEATH
	# =================================

	dead = true
	hurt = false
	attacking = false

	velocity = Vector2.ZERO

	$Attack1Hitbox.monitoring = false
	$Attack2Hitbox.monitoring = false
	$Attack3Hitbox.monitoring = false

	$AnimatedSprite.play("Death")

	yield($AnimatedSprite, "animation_finished")

	var pie = GoldenPieScene.instance()

	get_parent().add_child(pie)

	pie.global_position = global_position + Vector2(0, 100)

	queue_free()


# =================================
# START FIGHT
# =================================

func start_fight():

	fight_started = true


# =================================
# BOSS TRIGGER
# =================================

func _on_BossTrigger_body_entered(body):

	pass
