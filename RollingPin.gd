extends Area2D

export var speed = 500
export var gravitys = 200
export var launch_height = -60

var direction = 1
var velocity = Vector2()


func _ready():

	$AnimatedSprite.play("Throw")
	$Fire.emitting = true
	$FireTrail.emitting = true

	velocity.x = speed * direction
	velocity.y = launch_height

	connect("body_entered", self, "_on_body_entered")


func _physics_process(delta):

	velocity.y += gravitys * delta

	position += velocity * delta


func _on_body_entered(body):

	# Rolling pin hit something
	# Ignore Dag
	if body.name == "Player":
		return

	queue_free()
