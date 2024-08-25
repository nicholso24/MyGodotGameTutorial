extends Node2D

const MAX_CRABS = 20
const DIFFONE = 10
const DIFFTWO = 20

var current_crabs = 0
var crabs_spawned = 0
var current_score = 0

var crab_scene = load("res://Crab.tscn")
var spawn_location

func _ready():
	spawn_location = $Path2D/PathFollow2D
	spawn_crab()
	$SpawnTimer.start()
	$Label.text = str(current_score)
func _process(delta):
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
		
func spawn_crab():
	var crab = crab_scene.instantiate()
	spawn_location.progress_ratio = randf()
	add_child(crab)
	current_crabs += 1
	crab.dead.connect(crab_died)
	crab.bump.connect(spawn_crab)
	
	crab.position = spawn_location.position
	
	if(spawn_location.progress_ratio <= 0.25):
		spawn_location.progress_ratio = randf_range(0.26,1)
	elif(spawn_location.progress_ratio <= 0.5):
		var choice = randf()
		if(choice > 0.33):
			spawn_location.progress_ratio = randf_range(0,0.25)
		else:
			spawn_location.progress_ratio = randf_range(0.51,1)
	elif(spawn_location.progress_ratio <= 0.75):
		var choice = randf()
		if(choice > 0.33):
			spawn_location.progress_ratio = randf_range(0.76,1)
		else:
			spawn_location.progress_ratio = randf_range(0,0.5)
	else:
		spawn_location.progress_ratio = randf_range(0,0.75)
	
	var move_to = spawn_location.position
	crab.move(move_to)
	
	if(crabs_spawned > DIFFONE):
		$SpawnTimer.wait_time = 5
	elif(crabs_spawned > DIFFTWO):
		$SpawnTimer.wait_time = 3

func crab_died():
	current_score += 10
	current_crabs -= 1
	$Label.text = str(current_score)
	
func _on_spawn_timer_timeout():
	spawn_crab()

func _on_score_timer_timeout():
	current_score = current_score + 1 + current_crabs
	$Label.text = str(current_score)
