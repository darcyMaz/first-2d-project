extends CanvasLayer

# Tells Main to start the game.
signal start_game
var start_string = "Dodge the weird things!"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Let's us show messages like 'Get Ready!'
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over!")
	
	# Wait until the message timer has counted down.
	await $MessageTimer.timeout
	
	$Message.text = start_string
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	#   Point of this is to have a delay between "Dodge the weird things!"
	#	Message and the start button appearing. Ok I guess.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()
