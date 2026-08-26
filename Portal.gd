extends Area2D

export(String, FILE, "*.tscn") var world_scene
export var required_pies = 0
export var require_all_enemies = false


func _ready():
	pass


func _process(delta):

	var bodies = get_overlapping_bodies()

	for body in bodies:

		if body.name == "Player":

			# Check pie requirement
			if Global.pies < required_pies:
				return

			# Check enemy requirement
			if require_all_enemies:

				var enemies = get_tree().get_nodes_in_group("enemies")

				if enemies.size() > 0:
					return

			# Everything required has been completed
			get_tree().change_scene(world_scene)
