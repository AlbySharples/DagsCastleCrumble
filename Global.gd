extends Node

# Player stats
var lives = 3
var potions = 3
var pies = 0

# Game state
var game_time = 0.0


var spawn_point_name = "Default"

func reset_game():

	lives = 3
	potions = 1
	pies = 0
	game_time = 0.0


func add_potion(amount = 1):

	potions += amount


func use_potion():

	if potions > 0 and lives < 3:
		potions -= 1
		lives += 1
		return true

	return false


func lose_life():

	lives -= 1

	if lives <= 0:
		lives = 0
		return false

	return true


func collect_pie():

	pies += 1
