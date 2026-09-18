extends Node3D
class_name BackPack

## Back pack basic -> b_button impulso dependiendo direccion de movimiento


# DESCRIPCION: BackPack con bosters de poca duracion, a pesar de esto, son lo suficientemente fuertes para  permitir cambios bruscos de direccion, pueden usarse en el aire pero no permiten mantenerse elevado


@export var max_speed: float = 20.0
@export var acceleration = 100.0
@export var decelaration: float = 100.0
var input: Vector2
var player: Player

@onready var bost_timer: Timer = $Timer
@export var bost_time: float = 0.5

@onready var recovery_timer: Timer = $RecoveryTimer
@export var recovery_time: float = 0.1

var last_direction := Vector3.ZERO

signal is_bosting(value: bool)


func _ready() -> void:
    if not owner is Player:
        return
        
    player = owner
    bost_timer.connect('timeout', _on_bost_timeout)

    recovery_timer.connect('timeout', _on_recovery_timer_timeout)


func _physics_process(delta: float) -> void:
    input = player.input
    var direction := (player.transform.basis) * Vector3(
        input.x, 0.0, input.y
    ).normalized()

    if Input.is_action_just_pressed(player.actions['back_pack']):
        if bost_timer.is_stopped():
            bost_timer.start(bost_time)
            is_bosting.emit(true)
            last_direction = direction


    # back bost(dash)
    if bost_timer.time_left > 0.0 and input == Vector2.ZERO:
        var target_velocity := (player.transform.basis) * Vector3(
        0.0, 0.0, 1.0) * max_speed

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
    # direction bost(dash)
    if bost_timer.time_left > 0.0 and direction.length() > 0.0:
        var target_velocity := last_direction * max_speed

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
    # recovery
    if recovery_timer.time_left > 0.0:
        player.velocity.x = move_toward(
            player.velocity.x,
            0.0,
            decelaration * delta
        )
        player.velocity.z = move_toward(
            player.velocity.z,
            0.0,
            decelaration * delta
        )


func _on_bost_timeout() -> void:
    recovery_timer.start(recovery_time)


func _on_recovery_timer_timeout() -> void:
    is_bosting.emit(false)
