extends KinematicBody2D

export var speed = 150      # How fast this rolls/moves left per second
export var stop_x = 900     # World x position at which this despawns

func _physics_process(delta):
	var velocity = Vector2(-speed, 0)
	move_and_slide(velocity)
	$Sprite.rotation_degrees -= speed * delta  # Spin the sprite as it rolls
	if global_position.x <= stop_x:
		queue_free()  # Gone once it reaches the stop point

func _on_Hitbox_body_entered(body):
	if body.name == "Player":
		Global.lose_life()  # Hit the player: lose a life
		queue_free()
