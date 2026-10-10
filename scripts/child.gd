extends CharacterBody3D

var mat_1: StandardMaterial3D = preload("res://assets/art/textures/child_1.tres")
var mat_2: StandardMaterial3D = preload("res://assets/art/textures/child_2.tres")

var mats: Array[StandardMaterial3D] = [mat_1, mat_2]

func _ready() -> void:
	$trtr/Body.set_surface_override_material(0, mats.pick_random())
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
