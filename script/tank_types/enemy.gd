extends Tank

#Defines logic for the general time of the enemy tank.
class_name Enemy

#The standard states this enemy can be in
enum states {STAND, WANDER, TRACK}

#The maximum time values for the respected state timers
@export var WANDER_TIME_MAX := 1
@export var STAND_TIME_MAX := 0.5

#The distance at which enemy detects  the player
const TRACK_DISTANCE: float = 350.0
#Stalking boundries
const MAX_STALK_DISTANCE: float = TRACK_DISTANCE - 100
const MIN_STALK_DISTANCE: float = MAX_STALK_DISTANCE / 2

@onready
var player: Player = %player

#Timer for various state behaviors
var state_timer: Timer
#Timer that signifies the switch of the direction
var direction_timer: Timer

# the normalized direction of enemy
var direction: Vector2 = Vector2(0,0)
#Helper variable that rotates the direction 
var dir_rotation: int

#The current state of this enemy
var current_state: states

func _ready():
	super._ready() #Calling parent (tank) class _ready method
	
	#wander_timer.autostart = false
	#stand_timer.autostart = false
	
	state_timer = Timer.new()
	state_timer.autostart = true
	state_timer.timeout.connect(_on_state_timeout)
	
	direction_timer = Timer.new()
	direction_timer.one_shot = true
	
	self.add_child(state_timer)
	self.add_child(direction_timer)
	
	dir_rotation = 90
	
	
#Makes an enemy wander around the map
#Returns the velocity of the wandering
func wander(delta) -> Vector2:
	#print("wandering")
	
	#look_at(direction + position)
	
	velocity.x = move_toward(velocity.x, speed * direction.x, accel)
	velocity.y = move_toward(velocity.y, speed * direction.y, accel)
	move_and_slide()
	
	return velocity

#Makes enemy move around the player at certain distance
func stalk(delta):
	
	#Distance between player and this enemy
	var distance = position.distance_to(player.position)
	#update directio to look at the player
	direction = position.direction_to(player.position)
	
	if(direction_timer.is_stopped() or direction_timer.time_left <= 0):
		direction_timer.start(1)
		dir_rotation = -dir_rotation
		pass
		
	
	#look_at(direction + position)
	
	if(distance < MIN_STALK_DISTANCE):
		position -= direction * speed * delta
	elif(distance > MAX_STALK_DISTANCE):
		position += direction * speed * delta
	else:
		position += direction.rotated(deg_to_rad(dir_rotation)) * speed * delta

#Executes when the state timer is ran out
func _on_state_timeout():
	#In case of invalid input
	if(current_state == null):
		current_state = states.STAND
		
	#Swaps between the wander and stand states
	match states:
		states.WANDER:
			current_state = states.STAND
			state_timer.start(STAND_TIME_MAX)
		states.STAND:
			current_state = states.WANDER
			direction.x = randi_range(-1,1)
			direction.y = randi_range(-1,1)
			state_timer.start(WANDER_TIME_MAX)
	
	
func _physics_process(delta):
	
	#If player is close enough, go into tracking state
	if(position.distance_to(player.position) <= TRACK_DISTANCE and current_state != states.TRACK):
		state_timer.stop()
		current_state = states.TRACK
	
	#Basics of the state movement for now
		#-> State is switched to
		#-> State movement is executed and timer is started
		#-> Upon timer end, switch to a new state
	match current_state:
		states.WANDER:
			wander(delta)
		#Finding a player would cause stalking
		states.TRACK:
			stalk(delta)
	
