extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	MusicPlayer.play_music(preload("res://BackGroundMusic/Menu.wav"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().change_scene("res://Story.tscn")  # HELP
	pass # Replace with function body.


func _on_Button2_pressed():
	get_tree().change_scene("res://Help.tscn")  # HELP
	pass # Replace with function body.


func _on_Button3_pressed():
	get_tree().change_scene("res://AboutPage.tscn")  # ABOUT
	pass # Replace with function body.
	
func _on_Button4_pressed():
	get_tree().quit()  # EXIT
	
	pass # Replace with function body.


