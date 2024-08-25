extends CharacterBody2D

class_name Crab
var normal_speed = 0.5
var has_bump = true

signal dead
signal bump


func _ready():
	$AnimatedSprite2D.play("Idle")
	$CollisionBox.disabled = false

func _process(delta):
	var collision_info = move_and_collide(velocity * delta * normal_speed)
	
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		if(collision_info.get_collider() is Crab && has_bump):
			emit_signal("bump")
			has_bump = false
	
func death():
	emit_signal("dead")
	queue_free()
	
func move(position):
	velocity = position

func get_id():
	return 1
