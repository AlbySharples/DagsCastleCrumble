extends StaticBody2D

var triggered = false


func _ready():

	$AnimatedSprite.stop()
	$AnimatedSprite.animation = "Idle"
	$AnimatedSprite.frame = 0


func _on_Trigger_body_entered(body):

	if triggered:
		return

	if body.name == "Player":

		triggered = true

		$AnimatedSprite.play("Crumble")

		yield($AnimatedSprite, "animation_finished")

		$CollisionShape2D.disabled = true

		queue_free()
