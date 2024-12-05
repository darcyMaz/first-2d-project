extends Area2D
signal hit

# Setting speed as export, we can change the speed from the inspector.
@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		# If we don't do this the speed will be root 2 which is bigger than 1.
		# For this project we don't want that but it's a choice.
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	
	#position = position.clamp(Vector2.ZERO, screen_size)
	position = position.clamp(screen_size * 0.06, screen_size * 0.95)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

# This function is called when the player is hit by another 2D area.
func _on_body_entered(body: Node2D) -> void:
	hide() # Player dissapears after being hit.
	hit.emit()
	#Disable collision detection after the hit so detection happens once.
	$CollisionShape2D.set_deferred("disabled", true) 
	
func start(pos):
	position = pos #Sets position to the given starting position.
	show()
	$CollisionShape2D.disabled = false #Turns collision detection on for player.
