extends Control

onready var potion_count = $HUD/Potions/PotionCount
onready var timer_label = $HUD/Timer

onready var heart1 = $HUD/Lives/Heart1
onready var heart2 = $HUD/Lives/Heart2
onready var heart3 = $HUD/Lives/Heart3
onready var pie_count = $HUD/Pies

var full_heart = preload("res://HUDtools/FullHeartbg.png")
var empty_heart = preload("res://HUDtools/EmptyHeartbg.png")


func _ready():
	update_potions()
	update_lives()

	timer_label.text = "00:00"
	pie_count.text = "Pies: " + str(Global.pies)


func _process(delta):

	Global.game_time += delta

	var minutes = int(Global.game_time) / 60
	var seconds = int(Global.game_time) % 60
	pie_count.text = "Pies: " + str(Global.pies)
	timer_label.text = "%02d:%02d" % [minutes, seconds]

	update_potions()
	update_lives()


func update_potions():
	potion_count.text = "x" + str(Global.potions)


func update_lives():

	heart1.texture = full_heart if Global.lives >= 1 else empty_heart
	heart2.texture = full_heart if Global.lives >= 2 else empty_heart
	heart3.texture = full_heart if Global.lives >= 3 else empty_heart
