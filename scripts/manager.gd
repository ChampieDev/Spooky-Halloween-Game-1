extends Node3D

var can_change: bool = true
var can_snap: bool = false

var candy: Node

@onready var stairs: Marker3D = $StairsMarker
@onready var door: Marker3D = $DoorMarker


var dialogue_options: Array[String] = ["Trick or Treat!!", "Just gimme the candy.", "..."]

func _ready() -> void:
	Global.reset.connect(_reset)
	Global.feed.connect(feed)
	
	candy = find_child("CandyItem")
	
	candy.global_position = $Player/CandySpawn.global_position
	candy.reparent($Player/CandySpawn, true)
		
func go_to_door():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	$Player/Footsteps.play()
	tween.tween_property($Player, "global_position", door.global_position, 0.75)
	await tween.finished
	$Player/Footsteps.stop()
	tween.kill()
	await get_tree().create_timer(0.25).timeout
	open_door()
			
func open_door():
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	Global.door_open.emit()
	$DoorOpen.play()
	tween.tween_property($DoorHinge, "global_rotation:y", deg_to_rad(120.0), 0.5)
	await tween.finished
	$Ambience.volume_db = 2.0
	await get_tree().create_timer(0.5).timeout
	$anims.play("look_at_child")
	can_change = true
	can_snap = true
	Global.start_dialogue.emit(dialogue_options.pick_random())
			
func _reset():
	candy.show()
	$Player.global_position = stairs.global_position
	candy.global_position = $Player/CandySpawn.global_position
	$DoorHinge.rotation = Vector3.ZERO
	$anims.play("look_up")
	$DoorBell.play()
	await $DoorBell.finished
	go_to_door()
	
func feed(type: String):
	match type:
		"candy":
			candy.set_color(Color.ORANGE_RED)
		"bl":
			candy.set_color(Color.BLACK)
	candy.reparent(self, true)
	var tween = create_tween()
	tween.tween_property(candy, "global_position", $Monster/MouthMarker.global_position, 0.1)
	await tween.finished
	candy.hide()
