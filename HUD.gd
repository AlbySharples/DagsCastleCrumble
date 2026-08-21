extends Control

var potions = 1
var time = 0.0

onready var potion_count = $HUD/Potions/PotionCount
onready var timer_label = $HUD/Timer


func _ready():
	potion_count.text = "x" + str(potions)
	timer_label.text = "00:00"


func _process(delta):

	time += delta

	var minutes = int(time) / 60
	var seconds = int(time) % 60

	timer_label.text = "%02d:%02d" % [minutes, seconds]


func update_potions(amount):

	potions = amount
	potion_count.text = "x" + str(potions)
