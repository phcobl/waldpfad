extends Panel

@onready var dialogue_display: RichTextLabel = $DialogueDisplay
@onready var letter_timer: Timer = $LetterTimer
@onready var dialogue_sound: AudioStreamPlayer = $DialogueSound

var scene_text							# All available texts
var selected_text = []					# Currently select dialogue element
var selected_string : String = ""
var dialogue_pointer : int = 0			# Index of currently selected letter of selected_text
var in_progress : bool = false			# Dialogue in progress
var typing_in_progress : bool = false	# Currently typing out dialogue

func _ready() -> void:
	hide_box()
	DialogueSignalBus.connect("display_dialogue", _on_display_dialogue)
	scene_text = preload("res://dialogue/dialogue_en.csv")
	
func _on_display_dialogue(key, sound):
	if in_progress:
		next_line()
	else:
		in_progress = true
		get_tree().paused = true
		show_box()
		load_dialogue_for_key(key)
		dialogue_sound.stream = sound	# Audio of current talker. Transmitted via signal from Interactable -> Dialogue Bus -> this
		next_line()
	
	
func show_box():
	visible = true
	
func hide_box():
	visible = false

func load_dialogue_for_key(key):
	for i in scene_text.records:
		if i[0] == key:
			selected_text = i.duplicate()
			selected_text.remove_at(0) # Remove key
	if selected_text.is_empty():
		selected_text = ["ERROR", "ERROR: CAN'T FIND DIALOGUE"]

func next_line():
	if typing_in_progress:						# Complete current line if not fully typed
		typing_in_progress = false
		letter_timer.stop()
		dialogue_display.text = selected_string
		dialogue_pointer = 0
	elif selected_text.size() > 0:				# Actually get next line
		selected_string = selected_text[0]
		if selected_string.is_empty():			# Catch empty strings at end. This might cause problems if actual empty string is in dialogue.
			selected_text = []
			next_line()
		selected_text.remove_at(0)
		next_char()
		typing_in_progress = true
		letter_timer.start()
	else:										# Stop if no more new lines available
		in_progress = false
		get_tree().paused = false
		dialogue_sound.stream = null
		hide_box()
		
func next_char():
	if dialogue_pointer <= selected_string.length():
		dialogue_display.text = selected_string.left(dialogue_pointer)
		dialogue_pointer += 1
		if dialogue_display.text.right(1) != " " && dialogue_display.text.right(1) != "":
			dialogue_sound.play()
	else:
		typing_in_progress = false
		letter_timer.stop()
		dialogue_pointer = 0

func _on_letter_timer_timeout() -> void:
	next_char()
