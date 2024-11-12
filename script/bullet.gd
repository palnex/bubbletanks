extends Area2D

const SPEED_BULLET := 700


func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED_BULLET * delta

func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
