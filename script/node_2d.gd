extends Node2D

@onready var enemies_node = $Enemies

enum Prioruty {first, second, third}

# Called when the node enters the scene tree for the first time.
func _ready():
    var player = $player
    
    if player:
        player.set_enemies(enemies_node)
    else:
        print("plater not found")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
