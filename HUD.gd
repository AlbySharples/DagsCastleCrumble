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
	# Tick the game clock and refresh all HUD elements every frame
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
	# Show a full or empty heart icon for each of the 3 possible lives
	heart1.texture = full_heart if Global.lives >= 1 else empty_heart
	heart2.texture = full_heart if Global.lives >= 2 else empty_heart
	heart3.texture = full_heart if Global.lives >= 3 else empty_heart

func show_boss_banner(text: String):
	# Show a banner with the given text, then fade it out and hide it after 2.5s
	$BossBanner.text = text
	$BossBanner.visible = true
	$BossBanner.modulate.a = 1.0
	yield(get_tree().create_timer(2.5), "timeout")
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property($BossBanner, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	$BossBanner.visible = false
	tween.queue_free()
