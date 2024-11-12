extends Sprite2D

const rotation_speed := 10.0
var enemies_node = null 

func _ready():
	pass

func _process(delta):
	update_closest_enemy(delta)

func set_enemies(enemies):
	# Function to set the enemies reference
	enemies_node = enemies

func update_closest_enemy(delta):
	var min_distance = 1000
	var closest_node: Node2D = null
	for child in enemies_node.get_children():
		var distance = global_position.distance_to(child.global_position)
		if distance < min_distance:
			min_distance = distance
			closest_node = child
	if closest_node:
		rotate_gun(closest_node, delta)
		#print("Closest node is:", closest_node.name, "at distance:", min_distance)

func rotate_gun(child, delta):
	var direction = global_position.angle_to_point(child.global_position)
	rotation = lerp_angle(rotation, direction + PI/2, rotation_speed * delta) 

func shoot():
	const BULLET = preload("res://scenes/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation - PI/2
	%ShootingPoint.add_child(new_bullet)

func _on_timer_timeout():
	shoot()
