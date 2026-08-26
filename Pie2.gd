extends Area2D


func _ready():

	$AnimatedSprite.play("Spin")

	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body):

	if body.name == "Player":

		Global.collect_pie()

		queue_free()
