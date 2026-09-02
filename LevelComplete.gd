extends Node2D

onready var timer_label = $Timer
onready var lives_label = $"Lives Remaining"
onready var pies_label = $"Pies Collected"
onready var main_menu_button = $MainMenuButton

func _ready():
	
	MusicPlayer.play_music(preload("res://BackGroundMusic/Victory.wav"), -12)
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
	# MAIN MENU BUTTON
	# ================================

func _on_NextLevelButton_pressed():
	Global.lives = 3
	Global.potions = 3
	get_tree().change_scene("res://Dungeon1.tscn")
	pass # Replace with function body.
