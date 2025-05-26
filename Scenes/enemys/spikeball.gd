extends Node2D

# Tamaño anilla 3px
var floorDetected = false
var safeTimeOut = false
var rayCastInitValue = 18.5

func _ready():
	$raycast_floor_detection.target_position.y = rayCastInitValue
	$SafeTime.start()


func _process(delta: float) -> void:
	if not floorDetected and safeTimeOut:
		$raycast_floor_detection.target_position.y += 1
		if $raycast_floor_detection.is_colliding():
			floorDetected = true
			$raycast_floor_detection.target_position.y -= 3
			init_spikeball()


func init_spikeball():
	var numberOfChains = ($raycast_floor_detection.target_position.y - rayCastInitValue) / 3
	$SpikedBall.position.y += numberOfChains * 3
	for i in range(numberOfChains):
		var newRing = preload("res://Scenes/enemys/one_chain.tscn").instantiate()
		newRing.position = Vector2(3, (i + 1) * 3) # likely intended position logic
		add_child(newRing)
	$animation_rotation.play("regular_move")


func _on_SafeTime_timeout():
	safeTimeOut = true


func _on_area_colision_with_map_body_entered(body):
	$animation_rotation.speed_scale *= -1
