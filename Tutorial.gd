extends Node

onready var dag = get_parent().get_node("Player")


func _ready():
	print("Tutorial started")
	print("Dag found: ", dag)
