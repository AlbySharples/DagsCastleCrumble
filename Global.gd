extends Node

# Player stats
var lives = 3
var potions = 4
var pies = 0

# Game state
var game_time = 0.0
var current_level_start = "res://Entrance2.tscn"
var spawn_point_name = "Default"   # Name of the spawn Position2D to use when the next scene loads

func reset_game():
	# Resets stats for a fresh game
	lives = 3
	potions = 1
	pies = 0
	game_time = 0.0

func add_potion(amount = 1):
	potions += amount

func use_potion():
	# Spend a potion to heal one life, if possible
	SfxPlayer.play(preload("res://SFX/Heal.wav"))
	if potions > 0 and lives < 3:
		potions -= 1
		lives += 1
		return true
	return false

func lose_life():
	# Lose a life; trigger Game Over once lives hit 0
	SfxPlayer.play(preload("res://SFX/Hit.wav"))
	lives -= 1
	if lives <= 0:
		lives = 0
		get_tree().change_scene("res://GameOver.tscn")
		return false
	return true

func collect_pie():
	pies += 1
	SfxPlayer.play(preload("res://SFX/PickUp.mp3"))
