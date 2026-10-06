extends Control

func _on_mouse_detect_mouse_entered() -> void:
	$MouseDetect/CollisionShape2D.debug_color = Global.ON_COLOR
	Global.go_back.emit()

func _on_mouse_detect_mouse_exited() -> void:
	$MouseDetect/CollisionShape2D.debug_color = Global.OFF_COLOR
