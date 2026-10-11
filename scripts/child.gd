extends CharacterBody3D

var self_id: int = -1

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

var eye_pool: Dictionary = {
	"maroon": Color.MAROON,
	"dark slate blue": Color.WHITE
}

var head_pool: Dictionary = {
	"sandy brown": Color.SANDY_BROWN,
	"light pink": Color.LIGHT_PINK
}

var shirt_pool: Dictionary = {
	"dark cyan": Color.DARK_CYAN,
	"coral": Color.CORAL,
	"gold": Color.GOLD,
	"slate gray": Color.SLATE_GRAY,
	"white": Color.WHITE
}

var leg_pool: Dictionary = {
	"midnight blue": Color.MIDNIGHT_BLUE,
	"dark olive green": Color.DARK_OLIVE_GREEN,
	"chocolate": Color.CHOCOLATE,
	"charcoal": Color.SLATE_GRAY,
	"dark red": Color.DARK_RED
}


func _ready() -> void:
	
	Global.reset.connect(_reset)
	
	for i in range(10):
		generate_colors(i)
		
	await get_tree().create_timer(0.2).timeout
	
	var eye_text: String = eye_pool.find_key(Global.monster_2[0])
	var head_text: String = head_pool.find_key(Global.monster_1[1])
	var shirt_text: String = shirt_pool.find_key(Global.monster_1[2])
	var leg_text: String = leg_pool.find_key(Global.monster_2[3])
	
	Global.generate_description.emit(eye_text, head_text, shirt_text, leg_text)
	
	
	
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
	
	await get_tree().create_timer(1.0).timeout
	Global.reset.emit()

func generate_colors(id: int):
	var key_name = "child_color_%d" % id
	Global.child_colors[key_name] = [eye_colors.pick_random(), head_colors.pick_random(), shirt_colors.pick_random(), leg_colors.pick_random()]
	
func _reset():
	
	$monster.hide()
	$trtr.hide()
	
	self_id += 1
	for part in body_parts:
		if not part:
			continue
		
		var mat = mat_1.duplicate() as StandardMaterial3D
		
		match part.name:
			"Eyes":
				var global_id_color = Global.child_colors["child_color_" + str(self_id)]
				var color = global_id_color[0]
				mat.albedo_color = color
			"Legs":
				var global_id_color = Global.child_colors["child_color_" + str(self_id)]
				var color = global_id_color[3]
				mat.albedo_color = color
			"Shirt":
				var global_id_color = Global.child_colors["child_color_" + str(self_id)]
				var color = global_id_color[2]
				mat.albedo_color = color
			"Head":
				var global_id_color = Global.child_colors["child_color_" + str(self_id)]
				var color = global_id_color[1]
				mat.albedo_color = color
		
		part.set_surface_override_material(0, mat)
		
	$trtr.show()
		
	await get_tree().create_timer(5.0).timeout
	transform(randi_range(0, 1))
