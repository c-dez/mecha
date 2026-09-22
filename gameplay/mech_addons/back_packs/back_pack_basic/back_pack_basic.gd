extends Node3D
class_name BackPack




## DESCRIPCION: activate_special(callable) llama a la funcion que quiero que se active, que se mantiene activo durante special_duration /segundos, pensado asi para al heredar de esta clase solo tenga que override el _physics_process() 
# con activate_special() deseado


var _max_speed: float = 40.0
var _acceleration = 300.0
var _decelaration: float = 100.0

## special durartion
var _special_duration: float = 0.5
## Special recovery time
var _special_recovery: float = 0.1

## Nodo Timer 
@onready var special_duration_timer: Timer = $SpecialDurationTimer

## Nodo Timer
@onready var special_recovery_timer: Timer = $SpecialRecoveryTimer
var input: Vector2
var player: Player

var last_direction := Vector3.ZERO

## Signal desde back_pack_basic.gd para mostrar si esta en uso special(bool)
signal back_pack_special_state_signal(value: bool)



func _ready() -> void:
    set_player()
    set_timers_signals()


func _physics_process(delta: float) -> void:
    activate_special(dash_bost.bind(delta))


func _on_special_duration_timeout() -> void:
    special_recovery_timer.start(_special_recovery)


func _on_special_recovery_timeout() -> void:
    back_pack_special_state_signal.emit(false)


func set_player() -> void:
    if not owner is Player:
        return

    player = owner


## Toma player.input y regresa su direccion en Vector3
func get_direction() -> Vector3:
    input = player.input
    var direction := (player.transform.basis) * Vector3(
        input.x, 0.0, input.y
    ).normalized()

    return direction


## Incrementa la velocidad de movimiento durante x tiempo, e impide cambiar de direccion
func dash_bost(delta: float) -> void:
    var direction := get_direction()
    if special_duration_timer.is_stopped():
        special_duration_timer.start(_special_duration)
        back_pack_special_state_signal.emit(true)
        last_direction = direction

    # back bost(dash)
    if special_duration_timer.time_left > 0.0 and input == Vector2.ZERO:
        var target_velocity := (player.transform.basis) * Vector3(
        0.0, 0.0, 1.0) * _max_speed

        player.velocity.x = move_toward(
            player.velocity.x,
            target_velocity.x,
            _acceleration * delta
        )
        player.velocity.z = move_toward(
            player.velocity.z,
            target_velocity.z,
            _acceleration * delta
        )
    # direction bost(dash)
    if special_duration_timer.time_left > 0.0 and direction.length() > 0.0:
        var target_velocity := last_direction * _max_speed

        player.velocity.x = move_toward(
            player.velocity.x,
            target_velocity.x,
            _acceleration * delta

        )
        player.velocity.z = move_toward(
            player.velocity.z,
            target_velocity.z,
            _acceleration * delta

        )
    # recovery
    if special_recovery_timer.time_left > 0.0:
        player.velocity.x = move_toward(
            player.velocity.x,
            0.0,
            _decelaration * delta
        )
        player.velocity.z = move_toward(
            player.velocity.z,
            0.0,
            _decelaration * delta
        )


## Signals de timers para duracion y recovery de special
func set_timers_signals() -> void:
    special_duration_timer.connect('timeout', _on_special_duration_timeout)

    special_recovery_timer.connect('timeout', _on_special_recovery_timeout)

## activate_special(dash_bost.bind(delta))
func activate_special(callable: Callable) -> void:
    if Input.is_action_just_pressed(player.actions['back_pack']):
        callable.call()
    pass
