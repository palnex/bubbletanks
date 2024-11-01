extends CharacterBody2D

@export var speed: float = 500;
@export var accel: float = 75;
var enemies_node = null
@onready var guns = $guns

func _ready():
    pass

func _physics_process(delta):
    var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
    
    velocity.x = move_toward(velocity.x, speed * input_direction.x, accel)
    velocity.y = move_toward(velocity.y, speed * input_direction.y, accel)
    
    move_and_slide()

func set_enemies(enemies):
    enemies_node = enemies
    for gun in guns.get_children():
            gun.set_enemies(enemies_node)
             
