extends CharacterBody3D

@export var speed = 16
@export var fall_acceleration = 55
@export var jump_impulse = 22
@export var bounce_impulse = 20
var target_velocity = Vector3.ZERO
var diveBombing = false;

signal hit

# And this function at the bottom.
func die():
	hit.emit()
	queue_free()

func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node.
		$Pivot.basis = Basis.looking_at(direction)
		$AnimationPlayer.speed_scale = 2.5
	else:
		$AnimationPlayer.speed_scale = 1
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		if Input.is_action_pressed("jump"):
			diveBombing = true
			target_velocity.y = target_velocity.y - ((fall_acceleration * delta) * 2)
		else: 
			diveBombing = false
			target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)
		
		# Skip null collisions
		if collision.get_collider() == null:
			continue
		# If collision is with the ground
		if !collision.get_collider().is_in_group("mob"):
			bounce_impulse = 20
			GlobalScore.score_increment = 1
			break
			
		# If the collider is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# we check that we are hitting it from above.
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				if GlobalScore.score_increment < 32: GlobalScore.score_increment *= 2
				if diveBombing: bounce_impulse += 8
				else: bounce_impulse +=4
				target_velocity.y = bounce_impulse
				break

	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

	move_and_slide()


func _on_mob_detector_body_entered(body: Node3D) -> void:
	die()
