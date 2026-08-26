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

	velocity.y = launch_height

	connect("body_entered", self, "_on_body_entered")


func _physics_process(delta):

	# Set horizontal speed from current direction
	velocity.x = speed * direction

	# Gravity
	velocity.y += gravitys * delta

	position += velocity * delta


func _on_body_entered(body):

	# Ignore Dag
	if body.name == "Player":
		return

	# Damage enemies
	if body.has_method("take_damage"):
		body.take_damage()

	queue_free()
