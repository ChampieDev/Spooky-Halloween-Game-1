extends Node

var child_colors: Dictionary = {}

const ON_COLOR := Color("ff00006b")
const OFF_COLOR := Color("0099b36b")

signal go_back

signal door_open
signal door_close

signal snap

signal reset

signal start_dialogue(message: String)

signal feed(type: String)

signal generate_description(eye_color: String, head_color: String, shirt_color: String, leg_color: String)
