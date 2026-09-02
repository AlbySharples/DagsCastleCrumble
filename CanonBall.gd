extends Area2D

export var fall_speed = 350
export var damage = 1
export var lifetime = 6.0

var velocity = Vector2.ZERO
var falling = true
var life_timer = 0.0
var hit_player = false


func _ready():

	$AnimatedSprite.play("Falling")

	connect("body_entered", self, "_on_body_entered")


func _physics_process(delta):

	life_timer += delta

	# Falling
	if falling:

		velocity.y = fall_speed
		position += velocity * delta

	# Delete if it somehow survives too long
	if life_timer >= lifetime:
		queue_free()


func _on_body_entered(body):

	# Hit Dag
	if body.name == "Player":

		if not hit_player:
			hit_player = true
			body.take_damage()

		falling = false

		$AnimatedSprite.play("Landing")

		yield($AnimatedSprite, "animation_finished")

		queue_free()

		return


#	 Hit the ground/platform
	if body is StaticBody2D or body is KinematicBody2D:

		if falling:

			falling = false
			velocity = Vector2.ZERO

		# Move the cannonball slightly upward so the
		# landing animation happens on top of the floor
			$AnimatedSprite.stop()
			position.y -= 8

			$AnimatedSprite.play("Landing")
	
			yield($AnimatedSprite, "animation_finished")
			

			queue_free()
