extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(score)
	pass

func game_over() -> void:
	$Deathsound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()

func new_game():
	# This line get rid of any errant mobs at the start of the game.
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Dodge the weird things!")
	$Music.play()

func _on_mob_timer_timeout() -> void:
	# Create an instance of the Mob scene.
	var mob = mob_scene.instantiate()
	
	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath / MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Set the mob's direction to be perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI/2
	
	# Set the mob's position to that random location from above.
	mob.position = mob_spawn_location.position
	
	# Change the direction slightly with some randomness.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Finally spawn in the mob after having instantiating everything.
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
