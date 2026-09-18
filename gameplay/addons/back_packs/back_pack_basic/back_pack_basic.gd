extends Node3D
class_name BackPack

## Back pack basic -> b_button impulso dependiendo direccion de movimiento

@export var bost: float = 200.0
var input: Vector2
var player: Player

@onready var timer:Timer = $Timer

func _ready() -> void:
    if not owner is Player:
        return
    player = owner

func _physics_process(delta: float) -> void:
    input = player.input
    var direction := (player.transform.basis) * Vector3(
        input.x, 0.0, input.y
    )

    if Input.is_action_just_pressed(player.actions['back_pack']):
        # inicia timer
            # bost  player
        #termina timer
            # 0 bost player


        if input == Vector2.ZERO:
            # back dash
            pass

        player.velocity = direction * bost 
        # print('bost')
        
        pass

        
    pass