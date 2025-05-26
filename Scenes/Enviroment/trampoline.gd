extends Node2D

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _on_activation_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		$animaciones_trampolin.play("launch")
		body.velocity.y = -1000
