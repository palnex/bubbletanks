extends CharacterBody2D

#Base class for any tanks creates, containing the most basic definitions
class_name Tank

# The default speed definitions
@export var speed: float = 100;
@export var accel: float = 75;

# The default interactive definitions
var hp = 20.0
var gun_damage = 10

func _ready():
	pass
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Taking damage from the bullet
func take_damage():
	hp -= gun_damage
	#If death is reached
	if hp <= 0:
		queue_free()
	return hp
	
