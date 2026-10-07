extends Node3D

var obj_id: String = ""
var can_change: bool = true

const TRAVEL_TIME: float = 0.75

@onready var stairs: Marker3D = $StairsMarker
@onready var door: Marker3D = $DoorMarker


const OBJ_STATES = {
	"door": STATES.DOOR,
	"stairs": STATES.STAIRS,
	"peephole": STATES.PEEPHOLE
}

enum STATES {
	DOOR,
	STAIRS,
	PEEPHOLE
}

const ALLOWED_TRANSITIONS = {
	STATES.STAIRS: [STATES.DOOR],
	STATES.DOOR: [STATES.STAIRS, STATES.PEEPHOLE],     # Can only go back to stairs or look at peephole                 # Can only go back to stairs
	STATES.PEEPHOLE: [STATES.DOOR]                     # Can only step back to the door
}

var state: STATES = STATES.STAIRS

func _ready() -> void:
	$DoorArea.mouse_entered.connect(_on_mouse_entered.bind($DoorArea/DoorCollision, "door"))
	$DoorArea.mouse_exited.connect(_on_mouse_exited.bind($DoorArea/DoorCollision))
	
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
	
	if not can_change:
		return
	
	if not new_state in ALLOWED_TRANSITIONS[state]:
		return
	
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	state = new_state
	can_change = false
	match state:
		STATES.DOOR:
			Global.door_open.emit()
			tween.tween_property($Player, "global_position", door.global_position, TRAVEL_TIME)
			tween.tween_property($DoorHinge, "global_rotation:y", deg_to_rad(120.0), 0.25)
			await tween.finished
			can_change = true
		STATES.STAIRS:
			tween.tween_property($DoorHinge, "global_rotation:y", deg_to_rad(0.0), 0.25)
			tween.tween_property($Player, "global_position", stairs.global_position, TRAVEL_TIME)
			await tween.finished
			can_change = true
			Global.door_close.emit()
		STATES.PEEPHOLE:
			pass
