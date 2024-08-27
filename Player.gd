extends CharacterBody2D

# Sprite from GandalfHardcore on itch.io

var speed = 500

var can_parry = true
var can_move = true

func _ready():
	$Area2D/ParryHitbox.disabled = true

func _process(delta):
	if can_parry && Input.is_action_just_pressed("Parry"):
		parry()
	if can_move:
		var direction = Vector2.ZERO # (0,0)
		if Input.is_action_pressed("Move_Up"):
			direction.y -= 1
		if Input.is_action_pressed("Move_Down"):
			direction.y += 1
		if Input.is_action_pressed("Move_Right"):
			direction.x += 1
		if Input.is_action_pressed("Move_Left"):
			direction.x -= 1
	
		if direction.length() > 1:
			direction = direction.normalized()
		
		if direction.length() > 0:
			$AnimatedSprite2D.play("Running")
		else:
			$AnimatedSprite2D.play("Idle")
		
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		elif direction.x < 0:
			$AnimatedSprite2D.flip_h = false
		
		move_and_collide(direction * speed * delta)
	#self.position += direction * speed * delta

func parry():
	can_parry = false
	$Area2D/Hitbox.disabled = true
	can_move = false
	$Area2D/ParryHitbox.disabled = false
	$AnimatedSprite2D.play("Parry")
	
	
func death():
	set_process(false)
	$AnimatedSprite2D.play("Death")
	
func _on_area_2d_body_entered(body):
	if(!$Area2D/ParryHitbox.disabled):
		body.death()
	else:
		death()


func _on_animated_sprite_2d_animation_finished():
	if($AnimatedSprite2D.animation == "Parry"):
		can_move = true
		$Area2D/ParryHitbox.disabled = true
		$Area2D/Hitbox.disabled = false
		$ParryTimer.start()
		
	if($AnimatedSprite2D.animation == "Death"):
		queue_free()


func _on_parry_timer_timeout():
	can_parry = true
