extends Node3D

var can_change: bool = true
var can_snap: bool = false

@onready var stairs: Marker3D = $StairsMarker
@onready var door: Marker3D = $DoorMarker

func _ready() -> void:
	Global.reset.connect(_reset)
	_reset()
	
	$Player.global_position = stairs.global_position
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select") and can_snap:
		Global.snap.emit()
		get_tree().root.set_input_as_handled()
		
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
	Global.start_dialogue.emit("Trick or Treat!!")
			
func _reset():
	$DoorBell.play()
	await $DoorBell.finished
	go_to_door()
	
func feed(type: String):
	pass
