extends Node2D

onready var timer_label = $Timer
onready var lives_label = $"Lives Remaining"
onready var pies_label = $"Pies Collected"
onready var next_level_button = $NextLevelButton


func _ready():

	# ================================
	# FINAL TIME
	# ================================

	var minutes = int(Global.game_time) / 60
	var seconds = int(Global.game_time) % 60

	timer_label.text = "Time Taken: %02d:%02d" % [minutes, seconds]


	# ================================
	# LIVES REMAINING
	# ================================

	lives_label.text = "Lives Remaining: " + str(Global.lives)


	# ================================
	# PIES COLLECTED
	# ================================

	pies_label.text = "Pies Collected: " + str(Global.pies)


	# ================================
	# NEXT LEVEL BUTTON
	# ================================

	next_level_button.connect(
		"pressed",
		self,
		"_on_next_level_pressed"
	)


func _on_next_level_pressed():

	Global.game_time = 0.0


	get_tree().change_scene("res://Dungeon1.tscn")


func _on_NextLevelButton_pressed():
	pass # Replace with function body.
