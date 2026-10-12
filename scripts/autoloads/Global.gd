extends Node

var child_colors: Dictionary = {}

var avalible_nums = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

var monster_1
var monster_2

const ON_COLOR := Color("ff00006b")
const OFF_COLOR := Color("0099b36b")

signal go_back

signal door_open
signal door_close

signal snap

signal reset
signal start

signal start_dialogue(message: String)

signal feed(type: String)

signal generate_description(eye_color: String, head_color: String, shirt_color: String, leg_color: String)

func _ready() -> void:
	
	start.connect(_start)
	
func _start():
	await get_tree().create_timer(0.1).timeout
	
	var choice_1 = avalible_nums.pick_random()
	avalible_nums.erase(choice_1)
	monster_1 = child_colors["child_color_" + str(choice_1)]
	
	
	var choice_2 = avalible_nums.pick_random()
	avalible_nums.erase(choice_2)
	monster_2 = child_colors["child_color_" + str(choice_2)]
