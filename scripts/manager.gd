extends Node3D

var obj_id: String = ""

const OBJ_STATES = {
	"door": STATES.DOOR,
	"window": STATES.WINDOW,
	"stairs": STATES.STAIRS,
	"peephole": STATES.PEEPHOLE
}

enum STATES {
	WINDOW,
	DOOR,
	STAIRS,
	PEEPHOLE
}

var state: STATES = STATES.STAIRS

func _ready() -> void:
	$DoorArea.mouse_entered.connect(_on_mouse_entered.bind($DoorArea/DoorCollision, "door"))
	$DoorArea.mouse_exited.connect(_on_mouse_exited.bind($DoorArea/DoorCollision))
	$WindowArea.mouse_entered.connect(_on_mouse_entered.bind($WindowArea/WindowCollision, "window"))
	$WindowArea.mouse_exited.connect(_on_mouse_exited.bind($WindowArea/WindowCollision))
	
	Global.go_back.connect(change_state.bind(STATES.STAIRS))
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select") and obj_id in OBJ_STATES:
		print(obj_id)
		change_state(OBJ_STATES[obj_id])
	
func _on_mouse_entered(collision_obj: CollisionShape3D, id: String):
	collision_obj.debug_color = Global.ON_COLOR
	obj_id = id

func _on_mouse_exited(collision_obj: CollisionShape3D):
	collision_obj.debug_color = Global.OFF_COLOR
	obj_id = ""
	
func change_state(new_state: STATES):
	var previous_state = state
	state = new_state
	var tween = create_tween()
	match state:
		STATES.WINDOW:
			tween.tween_property($Player, "global_position", $WindowMarker.global_position, 0.25)
		STATES.DOOR:
			tween.tween_property($Player, "global_position", $DoorMarker.global_position, 0.25)
		STATES.STAIRS:
			tween.tween_property($Player, "global_position", $StairsMarker.global_position, 0.25)
		STATES.PEEPHOLE:
			pass
