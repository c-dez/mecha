extends Node3D
class_name Legs

## Clase base para Legs, se encarga de movimiento/ saltar
## 
## acceleration / decelaration - entre mayor el valor mayor el efecto
## 
## Propiedades:
    ## max_speed,
    ## acceleration,
    ## decelaration,
    ## jump_multiplier


@export var max_speed: float = 15
@export var acceleration: float = 20.0
@export var deceleration: float = 50.0

@export var jump_mult: float = 1.5

var player: Player

var is_bosting: bool = false

# var jump_button:String
func _ready() -> void:
    if not owner is Player:
        return

    player = owner

    var backpack = get_parent().get_node('BackPack')
    backpack.connect('is_bosting', _on_is_bosting)




func _physics_process(delta: float) -> void:
    if not is_bosting:
        move(delta)

    jump(player.actions['jump'])
    

func jump(action_button: String) -> void:
    if player.is_on_floor():
        if Input.is_action_just_pressed(action_button):
            player.velocity.y = player._jump_velocity * jump_mult


func move(delta: float) -> void:
    # var input := Input.get_vector("left", "right", "up", "down")
    #NO MOVERSE EN AIRE
    var input := player.input
    if not player.is_on_floor():
        return
    var direction := (player.transform.basis) * Vector3(
        input.x, 0.0, input.y
    )

    if direction.length() > 0.0:
        direction = direction.normalized()

        var target_velocity := direction * max_speed

        player.velocity.x = move_toward(
            player.velocity.x,
            target_velocity.x,
            acceleration * delta
        )

        player.velocity.z = move_toward(
            player.velocity.z,
            target_velocity.z,
            acceleration * delta
        )

    else:
        player.velocity.x = move_toward(
            player.velocity.x,
            0.0,
            deceleration * delta
        )

        player.velocity.z = move_toward(
            player.velocity.z,
            0.0,
            deceleration * delta
        )


func _on_is_bosting(value) -> void:
    is_bosting = value