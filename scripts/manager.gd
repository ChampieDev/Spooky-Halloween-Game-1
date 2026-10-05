extends Node3D

enum STATES {
	BACK,
	DOOR,
	WINDOW,
	PEEPHOLE
}

var state: STATES = STATES.BACK

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	match state:
		STATES.BACK:
			pass
		STATES.DOOR:
			pass
		STATES.WINDOW:
			pass
		STATES.PEEPHOLE:
			pass
