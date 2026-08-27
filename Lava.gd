extends Area2D


func _on_Lava_body_entered(body):

	if body.name == "Player":

		Global.lose_life()

		get_tree().reload_current_scene()
