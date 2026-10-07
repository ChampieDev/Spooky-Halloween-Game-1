extends CharacterBody3D

enum STATES {
	IDLE,
	WALKING,
}

var state := STATES.IDLE

func _ready() -> void:
	Global.door_close.connect(change_states.bind(STATES.WALKING))
	Global.door_open.connect(change_states.bind(STATES.IDLE))

func _process(delta: float) -> void:
	
	match state:
		STATES.IDLE:
			velocity.z = 0.0
		STATES.WALKING:
			velocity.z = 1.0
	
	move_and_slide()

func change_states(new_state: STATES):
	state = new_state
