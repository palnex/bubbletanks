extends CharacterBody2D

#Base class for any tanks creates, containing the most basic definitions
class_name Tank

# The default speed definitions
@export var speed: float = 100;
@export var accel: float = 75;

# The default interactive definitions
var hp = 20.0
var gun_damage = 10
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass
	
#Starts the specified timer with time between min and max
#Returns the time set 
func start_timer(timer: Timer, max_time: float = 1, min_time: float = max_time) -> float:
	if(timer == null):
		return 0
	var time: float = randf_range(min_time, max_time)
	timer.start(time)
	return timer.wait_time
	
#Taking damage from the bullet
#Returns the remaining hp
func take_damage():
	hp -= gun_damage
	#If death is reached
	if hp <= 0:
		queue_free()
	return hp
