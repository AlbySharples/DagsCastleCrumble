extends Camera2D

export(NodePath) var player_path        # Path to the player node the camera follows
export(NodePath) var background_path    # Path to the background, used to set camera limits
onready var player = get_node(player_path)
onready var background = get_node(background_path)

var shift_threshold = 200   # How far right of camera center the player can go before the camera starts following
var left_threshold = 200    # How far left of camera center the player can go before the camera starts following
var scroll_speed = 300      # (currently unused in the logic below)

func _ready():
	# Clamp the camera to the bounds of the background so it never shows past its edges
	var background_size = background.texture.get_size() * background.scale
	limit_left = background.global_position.x - background_size.x / 2
	limit_right = background.global_position.x + background_size.x / 2
	limit_top = background.global_position.y - background_size.y / 2
	limit_bottom = background.global_position.y + background_size.y / 2

func _process(delta):
	# Only move the camera once the player passes a threshold on either side,
	# so it doesn't track every tiny movement (a "dead zone" style follow)
	var target_x = global_position.x
	if player.global_position.x > global_position.x + shift_threshold:
		target_x = player.global_position.x - shift_threshold
	elif player.global_position.x < global_position.x - left_threshold:
		target_x = player.global_position.x + left_threshold
	# Smoothly ease toward the target x rather than snapping
	global_position.x = lerp(global_position.x, target_x, 8 * delta)
