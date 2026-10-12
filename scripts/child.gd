extends CharacterBody3D

var self_id: int = -1
var global_id_color: Array

var description: Array = []

@onready var eyes: MeshInstance3D = $trtr/Eyes
@onready var legs: MeshInstance3D = $trtr/Legs
@onready var shirt: MeshInstance3D = $trtr/Shirt
@onready var head: MeshInstance3D = $trtr/Head

@onready var body_parts = [eyes, legs, shirt, head]

var mat_1: StandardMaterial3D = preload("res://assets/art/textures/child_1.tres")

var eye_colors: Array[Color] = [Color.WHITE, Color.MAROON]
var head_colors: Array[Color] = [Color.SANDY_BROWN, Color.LIGHT_PINK]
var shirt_colors: Array[Color] = [Color.DARK_CYAN, Color.CORAL, Color.GOLD, Color.SLATE_GRAY, Color.WHITE]
var leg_colors: Array[Color] = [Color.BLUE, Color.GREEN, Color.SADDLE_BROWN, Color.SLATE_GRAY, Color.DARK_RED]

var eye_pool: Dictionary = {
	"maroon": Color.MAROON,
	"white": Color.WHITE
}

var head_pool: Dictionary = {
	"sandy brown": Color.SANDY_BROWN,
	"light pink": Color.LIGHT_PINK
}

var shirt_pool: Dictionary = {
	"dark cyan": Color.DARK_CYAN,
	"coral": Color.CORAL,
	"gold": Color.GOLD,
	"grey": Color.SLATE_GRAY,
	"white": Color.WHITE
}

var leg_pool: Dictionary = {
	"blue": Color.BLUE,
	"green": Color.GREEN,
	"brown": Color.SADDLE_BROWN,
	"grey": Color.SLATE_GRAY,
	"dark red": Color.DARK_RED
}


func _ready() -> void:
	
	Global.reset.connect(_reset)
	Global.feed.connect(feed)
	
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
		$anims.play("monster_die")
		await $anims.animation_finished
	else:
		$Reveal.play()
		$trtr.hide()
		$monster.show()
		$anims.play("monster_scare")
		await $anims.animation_finished
		get_tree().quit()
	
	await get_tree().create_timer(2.0).timeout
	if self_id < 9:
		Global.reset.emit()
		
func child_effect(got_bl: bool):
	if got_bl:
		$Gag.play()
	else:
		$Mmm.play()
		
	await get_tree().create_timer(2.0).timeout
	if self_id < 9:
		Global.reset.emit()

func generate_colors(id: int):
	var key_name = "child_color_%d" % id
	description = [eye_colors.pick_random(), head_colors.pick_random(), shirt_colors.pick_random(), leg_colors.pick_random()]
	Global.child_colors[key_name] = description
	
func _reset():
	
	$monster.hide()
	$trtr.hide()
	
	self_id += 1
	for part in body_parts:
		if not part:
			continue
		
		var mat = mat_1.duplicate() as StandardMaterial3D
		
		global_id_color = Global.child_colors["child_color_" + str(self_id)]
		
		match part.name:
			"Eyes":
				var color = global_id_color[0]
				mat.albedo_color = color
			"Legs":
				var color = global_id_color[3]
				mat.albedo_color = color
			"Shirt":
				var color = global_id_color[2]
				mat.albedo_color = color
			"Head":
				var color = global_id_color[1]
				mat.albedo_color = color
		
		part.set_surface_override_material(0, mat)
		
	$trtr.show()
		

func feed(type: String):
	await get_tree().create_timer(0.25).timeout
	match type:
		"candy":
			if Global.monster_1 == global_id_color or Global.monster_2 == global_id_color:
				transform(false)
			else:
				child_effect(false)
		"bl":
			if Global.monster_1 == global_id_color or Global.monster_2 == global_id_color:
				transform(true)
			else:
				child_effect(true)
