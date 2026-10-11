extends CharacterBody3D

@onready var eyes: MeshInstance3D = $trtr/Eyes
@onready var legs: MeshInstance3D = $trtr/Legs
@onready var shirt: MeshInstance3D = $trtr/Shirt
@onready var head: MeshInstance3D = $trtr/Head

@onready var body_parts = [eyes, legs, shirt, head]

var mat_1: StandardMaterial3D = preload("res://assets/art/textures/child_1.tres")

var eye_colors: Array[Color] = [Color.WHITE, Color.MAROON]
var head_colors: Array[Color] = [Color.SANDY_BROWN, Color.LIGHT_PINK]
var shirt_colors: Array[Color] = [Color.DARK_CYAN, Color.CORAL, Color.GOLD, Color.SLATE_GRAY, Color.WHITE]
var leg_colors: Array[Color] = [Color.MIDNIGHT_BLUE, Color.DARK_OLIVE_GREEN, Color.CHOCOLATE, Color.SLATE_GRAY, Color.DARK_RED]

var eye_color = eye_colors.pick_random()
var head_color = head_colors.pick_random()
var shirt_color = shirt_colors.pick_random()
var leg_color = leg_colors.pick_random()


func _ready() -> void:
	
	for i in range(10):
		generate_colors(i)
	
	for part in body_parts:
		if not part:
			continue
		
		var mat = mat_1.duplicate() as StandardMaterial3D
		
		match part.name:
			"Eyes":
				mat.albedo_color = eye_color
			"Legs":
				mat.albedo_color = leg_color
			"Shirt":
				mat.albedo_color = shirt_color
			"Head":
				mat.albedo_color = head_color
		
		part.set_surface_override_material(0, mat)
		
	await get_tree().create_timer(5.0).timeout
	transform(randi_range(0, 1))
	
func transform(dead: bool = false):
	if dead:
		$Explode.restart()
		$Explode2.play()
		$trtr.hide()
	else:
		$Transform.restart()
		$Reveal.play()
		$trtr.hide()
		$monster.show()

func generate_colors(id: int):
	var key_name = "child_color_%d" % id
	Global.child_colors[key_name] = [eye_colors.pick_random(), head_colors.pick_random(), shirt_colors.pick_random(), leg_colors.pick_random()]
