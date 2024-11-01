extends CharacterBody2D

enum EnemyType {TANK, INFANTRY}

@export var enemy_type: EnemyType = EnemyType.TANK
var hp: float
var gun_damage = 10


func _physics_process(delta):
    pass

func _ready():
    set_hp_based_on_type()
    
func set_hp_based_on_type():
    match enemy_type:
        EnemyType.TANK:
            hp = 200
        EnemyType.INFANTRY:
            hp = 20

func take_damage():
    hp -= gun_damage
    if hp <= 0:
        queue_free()
    
