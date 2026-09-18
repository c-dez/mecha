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

#   DESCRIPCION PIERNAS: piernas ligeras que permiten moverse y cambiar rapidamente de direccion, funcionan bien con bosters cortos en tierra, pueden saltar una moderada distancia
var leg_stats:LegStats

var max_speed: float = 1.0
var acceleration: float = 1.0
var deceleration: float = 1.0
var jump_mult: float = 1.5
var max_air_jumps:int
var cool_down:float
var can_air_jump:bool
var type := TYPE.basic

enum TYPE {
    basic,
    aerial
}



var player: Player

var is_bosting: bool = false

var current_air_jumps:int = 0
var _cd:float = 0.0

# var jump_button:String
func _ready() -> void:
    set_player()
    set_signals()
    set_stats()


func _physics_process(delta: float) -> void:
    if not is_bosting:
        move(delta)

    jump(player.actions['jump'])
    air_jump(player.actions['jump'])
    recharge_cool_down(delta)
    

func jump(action_button: String) -> void:
    if player.is_on_floor():
        if Input.is_action_just_pressed(action_button):
            player.velocity.y = player._jump_velocity * jump_mult


func air_jump(action_button:String):
    if player.is_on_floor():
        return
    if not can_air_jump:
        return

    if current_air_jumps > 0:
        if Input.is_action_just_pressed(action_button):
            player.velocity.y = player._jump_velocity * jump_mult
            current_air_jumps -= 1


func recharge_cool_down(delta:float)->void:
    if not can_air_jump:
        return
    
    if current_air_jumps <= max_air_jumps:
        _cd -= delta
        if _cd <= 0.0:
            current_air_jumps += 1
            _cd = cool_down


func move(delta: float) -> void:
    var input := player.input
    # NO MOVERSE EN AIRE
    # if not player.is_on_floor():
    #     return
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

## true cuando back pack esta en bosting(dash)
func _on_is_bosting(value) -> void:
    is_bosting = value


func set_player() -> void:
    if not owner is Player:
        return

    player = owner
    leg_stats = player.leg_stats

## Intencion: pueda usar signals universales en este caso de backpak (por que necesito saber cuando esta activado para bloquear movimiento en este script), y que se encargue de asignar los signals en signals_arr
func set_signals() -> void:
    var addons: Node3D = get_parent()
    var signal_str: String
    for child in addons.get_children():
        if child is BackPack:
            var signals_arr = child.signals_arr
            for i in range(signals_arr.size()):
                signal_str = signals_arr[i]

            match signal_str:
                'is_bosting':
                    child.connect(signal_str, _on_is_bosting)
                _:
                    printerr('signal desconocido')


func set_stats()->void:
    max_speed = leg_stats.max_speed
    acceleration = leg_stats.acceleration
    deceleration = leg_stats.deceleration
    jump_mult = leg_stats.jump_mult
    max_air_jumps = leg_stats.max_air_jumps
    cool_down = leg_stats.cool_down

    current_air_jumps = max_air_jumps
    match leg_stats.type:
        leg_stats.TYPE.basic:
            type = TYPE.basic
        leg_stats.TYPE.aerial:
            type = TYPE.aerial
        
        _:
            pass

    if type == TYPE.aerial:
        can_air_jump = true
    else:
        can_air_jump = false
    
