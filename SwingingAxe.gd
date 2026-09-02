extends Node2D

export var swing_angle = 90.0        # Max angle (degrees) the axe swings to either side
export var swing_speed = 1.5         # How fast the swing oscillates
export var swing_direction = 1.0     # Multiplier to flip or scale the swing direction

var time = 0.0

func _process(delta):
	time += delta
	# Swing the axe back and forth using a sine wave
	$Pivot/AxeAndChain.rotation_degrees = sin(time * swing_speed) * swing_angle * swing_direction

func _on_AxeHitbox_body_entered(body):
	if body.name == "Player":
		Global.lose_life()
