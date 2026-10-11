extends Control

@onready var dialogue: RichTextLabel = $MarginContainer/DialoguePanel/Dialogue
@onready var candy_button: Button = $CandySelect/HBoxContainer/Candy
@onready var bl_button: Button = $CandySelect/HBoxContainer/BlackLiquorice
@onready var description: RichTextLabel = $Newspaper/TextContainer/Description

var voice_1: AudioStreamMP3 = preload("res://assets/audio/voice.mp3")
var voice_2: AudioStreamOggVorbis = preload("res://assets/audio/voice2.ogg")

var voices = [voice_1, voice_2]

var bl_left: int = 4

func _ready() -> void:
	Global.start_dialogue.connect(display_text)
	Global.generate_description.connect(_generate_description)
	Global.reset.connect(_reset)
	
	$MarginContainer/DialoguePanel.hide()
	
	$Voice.stream = voices.pick_random()
	
	candy_button.pressed.connect(button_pressed.bind("Candy"))
	bl_button.pressed.connect(button_pressed.bind("BlackLiquorice"))
	
	candy_button.mouse_entered.connect(button_hover_on.bind("Candy"))
	bl_button.mouse_entered.connect(button_hover_on.bind("BlackLiquorice"))
	
	candy_button.mouse_exited.connect(button_hover_off.bind("Candy"))
	bl_button.mouse_exited.connect(button_hover_off.bind("BlackLiquorice"))
	
	$Newspaper.show()
	$anims.play("show_newspaper")
	$Fade.show()
	await get_tree().create_timer(25.0).timeout
	$Newspaper.hide()
	Global.reset.emit()
	await get_tree().create_timer(0.2).timeout
	var tween = create_tween()
	tween.tween_property($Fade, "modulate:a", 0.0, 0.25)
	
	candy_button.disabled = true
	bl_button.disabled = true

	
func _process(delta: float) -> void:
	%BLCount.text = "[wave amp=20.0 freq=3.0] " + str(int(%BLLeft.value)) + "[/wave]"
	%BLLeft.value = bl_left
	if bl_left <= 0:
		bl_button.disabled = true

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
	$anims.play("show_options")
	
func button_pressed(type: String):
		
	$Click.play()
	if type == "Candy":
		Global.feed.emit("candy")
	else:
		Global.feed.emit("bl")
		bl_left -= 1
	candy_button.disabled = true
	bl_button.disabled = true

func button_hover_on(type: String):
	if type == "Candy" and candy_button.disabled:
		return
		
	if type == "Candy":
		var tween = create_tween()
		tween.tween_property(candy_button, "scale", Vector2(1.1, 1.1), 0.1)
	else:
		var tween = create_tween()
		tween.tween_property(bl_button, "scale", Vector2(1.1, 1.1), 0.1)
	
func button_hover_off(type: String):
	if type == "Candy" and candy_button.disabled:
		return
		
	if type == "Candy":
		var tween = create_tween()
		tween.tween_property(candy_button, "scale", Vector2(1.0, 1.0), 0.1)
	else:
		var tween = create_tween()
		tween.tween_property(bl_button, "scale", Vector2(1.0, 1.0), 0.1)
		
func _generate_description(eye_color: String, head_color: String, shirt_color: String, leg_color: String):
	
	var spooky_newspaper = "WARNING: This Halloween night, monsters invade. Beware of them and don't give them candy. They are disguised as children, the first wearing a [b]" + shirt_color + "[/b] shirt, and has a [b]" + head_color + "[/b] head. The second has [b]" + eye_color + "[/b]-glowing eyes and [b]" + leg_color + "[/b] legs. Be careful."
	
	var newspaper_templates = [spooky_newspaper]
	
	description.text = newspaper_templates.pick_random()
	
func _reset():
	$anims.play("RESET")
	
	candy_button.scale = Vector2.ONE
	bl_button.scale = Vector2.ONE
	
	candy_button.disabled = true
	bl_button.disabled = true
	
	
