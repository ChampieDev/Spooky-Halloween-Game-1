extends Control

@onready var dialogue: RichTextLabel = $MarginContainer/DialoguePanel/Dialogue

var voice_1: AudioStreamMP3 = preload("res://assets/audio/voice.mp3")
var voice_2: AudioStreamOggVorbis = preload("res://assets/audio/voice2.ogg")

var voices = [voice_1, voice_2]

func _ready() -> void:
	Global.start_dialogue.connect(display_text)
	$MarginContainer/DialoguePanel.hide()
	
	$Voice.stream = voices.pick_random()

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
	
	
