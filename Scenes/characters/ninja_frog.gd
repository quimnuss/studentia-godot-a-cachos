extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -450.0
var health = 100
var direction
var allow_animation:bool = false
var leaved_floor: bool = false
var had_jump: bool = false
var max_jump:int = 2
var count_jump: int = 0
var double_jump: bool = false
var ray_cast_dimension = 14
var stuck_on_wall: bool = false


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$animaciones.play("appear")
	$rayCast_walljump.target_position.x =ray_cast_dimension

func _physics_process(delta):
	if is_on_floor():
		leaved_floor = false
		had_jump = false
		count_jump = 0
	# Add the gravity.
	if not is_on_floor():
		if not leaved_floor:
			$coyote_timer.start()
			leaved_floor = true
	velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and rigth_to_jump():
		if count_jump == 1:
			double_jump = true
			
		count_jump += 1
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if $rayCast_walljump.get_collider():
		if $rayCast_walljump.get_collider().is_in_group("wall_jump"):
			if velocity.y > 0:
				count_jump = 0
				velocity.y = 0
			stuck_on_wall= true
		else: stuck_on_wall=false
	else: stuck_on_wall = false
	move_and_slide()
	decide_animation()	

func decide_animation():
	
	if direction < 0:
		$animaciones.flip_h = true
		$rayCast_walljump.target_position.x = -ray_cast_dimension
	elif direction > 0:
		$animaciones.flip_h = false
		$rayCast_walljump.target_position.x = -ray_cast_dimension
	if double_jump:
		double_jump = false
		allow_animation = false	
		$animaciones.play("double_jump")
	if not allow_animation: return
	if stuck_on_wall:
		$animaciones.play("wall_jump")
	else:
		if velocity.x == 0:
			$animaciones.play("idle")
		elif velocity.x < 0:
			$animaciones.play("run")
		elif velocity.x > 0:
			$animaciones.play("run")
		if velocity.y > 0:
			$animaciones.play("jump_down")
		elif velocity.y < 0:
			$animaciones.play("jump_up")
	




func rigth_to_jump():
	if had_jump: 
		if count_jump < max_jump: return true
		else: return false
	if is_on_floor() || stuck_on_wall:
		had_jump = true
		return true
		
	elif not $coyote_timer.is_stopped(): 
		had_jump = true
		return true

func _on_animaciones_animation_finished():
	allow_animation= true
	
func _on_coyote_timer_timeout():
		pass
func _on_damage_detection_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	health -= 10
	pass # Replace with function body.
