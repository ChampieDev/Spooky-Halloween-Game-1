extends Node3D

var obj_id: String = ""

const TRAVEL_TIME: float = 0.5

@onready var stairs: Marker3D = $StairsMarker
@onready var window: Marker3D = $WindowMarker
@onready var door: Marker3D = $DoorMarker


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

const ALLOWED_TRANSITIONS = {
	STATES.STAIRS: [STATES.DOOR, STATES.WINDOW],
	STATES.DOOR: [STATES.STAIRS, STATES.PEEPHOLE],     # Can only go back to stairs or look at peephole
	STATES.WINDOW: [STATES.STAIRS],                    # Can only go back to stairs
	STATES.PEEPHOLE: [STATES.DOOR]                     # Can only step back to the door
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
	
	if not new_state in ALLOWED_TRANSITIONS[state]:
		return
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	state = new_state
	match state:
		STATES.WINDOW:
			tween.tween_property($Player, "global_position", window.global_position, TRAVEL_TIME)
		STATES.DOOR:
			tween.tween_property($Player, "global_position", door.global_position, TRAVEL_TIME)
		STATES.STAIRS:
			tween.tween_property($Player, "global_position", stairs.global_position, TRAVEL_TIME)
		STATES.PEEPHOLE:
			pass
