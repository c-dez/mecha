extends Node3D
class_name BackPack

## Back pack basic -> b_button impulso dependiendo direccion de movimiento


# DESCRIPCION: BackPack con bosters de poca duracion, a pesar de esto, son lo suficientemente fuertes para  permitir cambios bruscos de direccion, pueden usarse en el aire pero no permiten mantenerse elevado


var _max_speed: float = 20.0
var _acceleration = 100.0
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
## true si esta activado
signal special_state_signal(value: bool)
var signals_arr: Array = [
    'special_state_signal',
]


func _ready() -> void:
    set_player()
    special_duration_timer.connect('timeout', _on_bost_timeout)

    special_recovery_timer.connect('timeout', _on_recovery_timer_timeout)


func _physics_process(delta: float) -> void:
    if Input.is_action_just_pressed(player.actions['back_pack']):
        dash_bost(get_direction(), delta)




func _on_bost_timeout() -> void:
    special_recovery_timer.start(_special_recovery)


func _on_recovery_timer_timeout() -> void:
    special_state_signal.emit(false)


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
func dash_bost(direction: Vector3, delta: float) -> void:
    # if Input.is_action_just_pressed(player.actions['back_pack']):
    if special_duration_timer.is_stopped():
        special_duration_timer.start(_special_duration)
        special_state_signal.emit(true)
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
