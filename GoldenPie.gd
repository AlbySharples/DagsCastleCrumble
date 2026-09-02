extends Area2D

func _ready():
	pass   # Nothing to set up on ready

func _on_GoldenPie_body_entered(body):
	if body.name == "Player":
		# Picking up the golden pie completes the game
		Global.collect_pie()
		get_tree().change_scene("res://GameComplete.tscn")
		queue_free()
