extends Area2D

export(String, FILE, "*.tscn") var next_scene_path
export var target_spawn_name = "Default"  # matches a spawn Position2D in the next scene

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Tell the next scene which spawn point to use, then transition
		Global.spawn_point_name = target_spawn_name
		set_deferred("monitoring", false)   # Stop monitoring so this can't re-trigger before the scene changes
		get_tree().change_scene(next_scene_path)
