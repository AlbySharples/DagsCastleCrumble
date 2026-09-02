extends Area2D

func _ready():
	$AnimatedSprite.play("Spin")   # Idle spin animation for the pickup
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "Player":
		Global.collect_pie()   # Collect this pie and remove the pickup
		queue_free()
