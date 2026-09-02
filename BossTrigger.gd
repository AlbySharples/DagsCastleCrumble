extends Area2D


func _ready():

	var dag = get_tree().get_root().get_node("Dungeon3/Player")

	# BEFORE THE BOSS TRIGGER:
	# Dag can move and jump, but cannot shoot.
	dag.tutorial_can_shoot = false


func _on_BossTrigger_body_entered(body):

	if body.name != "Player":
		return

	var dag = body

	# =================================
	# BOSS INTRO - LOCK EVERYTHING
	# =================================

	dag.tutorial_can_move = false
	dag.tutorial_can_jump = false
	dag.tutorial_can_shoot = false

	# Show banner
	get_tree().get_root().get_node("Dungeon3/HUD").show_boss_banner(
		"Defeat King Crust to escape \nwith the golden pie!"
	)

	# =================================
	# WAIT 3 SECONDS
	# =================================

	yield(get_tree().create_timer(3.0), "timeout")

	# =================================
	# UNLOCK EVERYTHING
	# =================================

	dag.tutorial_can_move = true
	dag.tutorial_can_jump = true
	dag.tutorial_can_shoot = true

	# Start King Crust
	get_tree().get_root().get_node("Dungeon3/KingCrust").start_fight()

	queue_free()
