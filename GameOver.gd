extends Node2D

onready var menu_button = $Menu
onready var restart_button = $Restart

func _ready():
	
	MusicPlayer.play_music(preload("res://BackGroundMusic/GameOver.mp3"))   # Play the game-over music
	# Wire up button presses to their handlers
	menu_button.connect(
		"pressed",
		self,
		"_on_menu_pressed"
	)
	restart_button.connect(
		"pressed",
		self,
		"_on_restart_pressed"
	)

func _on_menu_pressed():
	get_tree().change_scene("res://Home.tscn")   # Back to the home/main menu

func _on_restart_pressed():
	# Reset run state, then restart from the current level's starting point
	Global.lives = 3
	Global.potions = 3
	Global.pies = 0
	get_tree().change_scene(Global.current_level_start)
