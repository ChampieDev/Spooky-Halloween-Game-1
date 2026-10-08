extends Control

func _ready() -> void:
	Global.snap.connect(_take_picture)

func _on_mouse_detect_mouse_entered() -> void:
	$MouseDetect/CollisionShape2D.debug_color = Global.ON_COLOR
	Global.go_back.emit()

func _on_mouse_detect_mouse_exited() -> void:
	$MouseDetect/CollisionShape2D.debug_color = Global.OFF_COLOR
		
func _take_picture():
	await RenderingServer.frame_post_draw
	var image = get_viewport().get_texture().get_image()
	var texture = ImageTexture.create_from_image(image)
	$TextureRect.texture = texture
	$anims.play("camera_flash")
	await get_tree().create_timer(3.0).timeout
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property($TextureRect, "modulate:a", 0.0, 0.25)
