extends CharacterBody2D


const SPEED = 200
const RAY_FLOOR_POSITION_X = 60
const RAY_WALLTARGET_POSITION_X = 60
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	velocity.x = SPEED
	$raycast_floor_detection.position.x = RAY_FLOOR_POSITION_X
	$raycast_wall_detection.position.x = RAY_WALLTARGET_POSITION_X
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if not $raycast_floor_detection.is_colliding() || $raycast_wall_detection.is_colliding():
		velocity.x *= -1
		$raycast_floor_detection.position.x *= -1
		$raycast_wall_detection.position.x *= -1
		
 
		move_and_slide()
