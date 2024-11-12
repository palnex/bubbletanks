extends Tank

#Defines logic for the general time of the enemy tank.
class_name Enemy

#The standard states this enemy can be in
enum states {ENGAGE, WANDER, STAND}

#The maximum time values for the respected state timers
const WANDER_TIME_MAX := 2
const STAND_TIME_MAX := 1

#While respective timer runs, behavior of respective state is executed
var wander_timer: Timer
var stand_timer: Timer

# The movement direction of the enemy
var direction_x: float = 0.0
var direction_y: float = 0.0

#The current state of this enemy
var current_state: states

func _ready():
	super._ready() #Calling parent (tank) class _ready method
	
	#wander_timer.autostart = false
	#stand_timer.autostart = false
	
	wander_timer = Timer.new()
	stand_timer = Timer.new()
	
	self.add_child(wander_timer)
	self.add_child(stand_timer)
	
	wander_timer.timeout.connect(_on_wander_timeout)
	stand_timer.timeout.connect(_on_stand_timeout)
	
#Makes an enemy wander around the map
#Returns the velocity of the wandering
func wander() -> Vector2:
	#print("wandering")
	velocity.x = move_toward(velocity.x, speed * direction_x, accel)
	velocity.y = move_toward(velocity.y, speed * direction_y, accel)
	move_and_slide()
	return velocity

func start_wondering():
	stand_timer.stop()
	
	current_state = states.WANDER
	wander_timer.start(WANDER_TIME_MAX)
	
	direction_x = randi_range(-1,1)
	direction_y = randi_range(-1,1)
	
func start_standing():
	wander_timer.stop()
	
	current_state = states.STAND
	stand_timer.start(STAND_TIME_MAX)
	
func _on_wander_timeout():
	wander_timer.stop()
	start_standing()
	
func _on_stand_timeout():
	stand_timer.stop()
	start_wondering()
	
func _physics_process(delta):
	match current_state:
		0:
			#Start wondering this tank is in nonoe of the state
			start_wondering()
		states.WANDER:
			wander()
