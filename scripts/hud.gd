extends Control

@onready var dialogue: RichTextLabel = $MarginContainer/DialoguePanel/Dialogue
@onready var candy_button: Button = $MarginContainer2/HBoxContainer/Candy
@onready var bl_button: Button = $MarginContainer2/HBoxContainer/BlackLiquorice

var voice_1: AudioStreamMP3 = preload("res://assets/audio/voice.mp3")
var voice_2: AudioStreamOggVorbis = preload("res://assets/audio/voice2.ogg")

var voices = [voice_1, voice_2]

func _ready() -> void:
	Global.start_dialogue.connect(display_text)
	$MarginContainer/DialoguePanel.hide()
	
	$Voice.stream = voices.pick_random()
	
	candy_button.pressed.connect(button_pressed.bind("Candy"))
	bl_button.pressed.connect(button_pressed.bind("BlackLiquorice"))
	
	candy_button.mouse_entered.connect(button_hover_on.bind("Candy"))
	bl_button.mouse_entered.connect(button_hover_on.bind("BlackLiquorice"))
	
	candy_button.mouse_exited.connect(button_hover_off.bind("Candy"))
	bl_button.mouse_exited.connect(button_hover_off.bind("BlackLiquorice"))
	
func _process(delta: float) -> void:
	pass

func _on_mouse_detect_mouse_entered() -> void:
	$MouseDetect/CollisionShape2D.debug_color = Global.ON_COLOR
	Global.go_back.emit()

func _on_mouse_detect_mouse_exited() -> void:
	$MouseDetect/CollisionShape2D.debug_color = Global.OFF_COLOR

func display_text(message: String):
	$MarginContainer/DialoguePanel.show()
	dialogue.visible_characters = 0
	dialogue.text = message
	for i in message.length():
		dialogue.visible_characters += 1
		$Voice.play()
		await get_tree().create_timer(0.05).timeout
	await get_tree().create_timer(1.5).timeout
	$MarginContainer/DialoguePanel.hide()
	
func button_pressed(type: String):
	if type == "Candy":
		Global.feed.emit("candy")
	else:
		Global.feed.emit("bl")

func button_hover_on(type: String):
	if type == "Candy":
		var tween = create_tween()
		tween.tween_property(candy_button, "scale", Vector2(1.1, 1.1), 0.1)
	else:
		var tween = create_tween()
		tween.tween_property(bl_button, "scale", Vector2(1.1, 1.1), 0.1)
	
func button_hover_off(type: String):
	if type == "Candy":
		var tween = create_tween()
		tween.tween_property(candy_button, "scale", Vector2(1.0, 1.0), 0.1)
	else:
		var tween = create_tween()
		tween.tween_property(bl_button, "scale", Vector2(1.0, 1.0), 0.1)
