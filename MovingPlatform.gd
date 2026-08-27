extends KinematicBody2D

export var move_distance = 100
export var move_speed = 60

var direction = 1
var velocity = Vector2.ZERO
var start_position = Vector2()


func _ready():

	start_position = global_position


func _physics_process(delta):

	velocity.x = direction * move_speed

	move_and_slide(velocity, Vector2.UP)

	if global_position.x >= start_position.x + move_distance:
		direction = -1

	elif global_position.x <= start_position.x - move_distance:
		direction = 1
