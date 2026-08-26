extends Area2D

export var speed = 500
export var damage = 1
export var lifetime = 5.0

var direction = 1
var life_timer = 0.0


func _ready():

	connect("body_entered", self, "_on_body_entered")


func _physics_process(delta):

	# Move horizontally
	position.x += speed * direction * delta

	# Rotate the arrow depending on direction
	if direction == -1:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

	# Remove arrow after a few seconds
	life_timer += delta

	if life_timer >= lifetime:
		queue_free()


func _on_body_entered(body):

	# Hit Dag
	if body.name == "Player":

		body.take_damage()

		queue_free()
