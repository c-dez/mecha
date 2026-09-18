extends Node3D
class_name Legs


@export var max_speed: float = 5.0
@export var acceleration: float = 10.0
@export var deceleration: float = 8.0
@export var jump_mult: float = 1.0

var player: Player

var jump_button:String
func _ready() -> void:
    if not owner is Player:
        return

    player = owner
    jump_button = player.actions['jump']

func _physics_process(delta: float) -> void:
    move(delta)
    jump(jump_button)
    

func jump(action_button: String) -> void:
    if player.is_on_floor():
        if Input.is_action_just_pressed(action_button):
            player.velocity.y = player._jump_velocity * jump_mult


func move(delta: float) -> void:
    # var input := player.get_player_input()
    var input := Input.get_vector("left", "right", "up", "down")
    #NO MOVERSE EN AIRE
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
