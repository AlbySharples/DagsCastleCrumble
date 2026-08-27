extends Camera2D

export(NodePath) var player_path
export(NodePath) var background_path

onready var player = get_node(player_path)
onready var background = get_node(background_path)

var shift_threshold = 200
var left_threshold = 200
var scroll_speed = 300

func _ready():
	var background_size = background.texture.get_size() * background.scale

	limit_left = background.global_position.x - background_size.x / 2
	limit_right = background.global_position.x + background_size.x / 2
	limit_top = background.global_position.y - background_size.y / 2
	limit_bottom = background.global_position.y + background_size.y / 2

func _process(delta):

	var target_x = global_position.x

	if player.global_position.x > global_position.x + shift_threshold:
		target_x = player.global_position.x - shift_threshold

	elif player.global_position.x < global_position.x - left_threshold:
		target_x = player.global_position.x + left_threshold

	global_position.x = lerp(global_position.x, target_x, 8 * delta)
