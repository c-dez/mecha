extends Node3D
class_name Legs


## DESCRIPCION :
##
##

# FUNCIONAMIENTO:
    #

var player: Player
var leg_stats: LegStats
# Campos internos, lee los valores de leg_stats:LegStats
var _max_speed: float = 1.0
var _acceleration: float = 1.0
var _deceleration: float = 1.0
## Multiplicador de fuerza de salto 1.5 == +50%
var _jump_mult: float = 1.5
## Basic,Aerial (enum) -> tal vez sea inecesario 
var _type: int = 0
var _max_air_jumps: int = 0
## tiempo de cool down de habilidad
var _cool_down: float = 0.0
##  Cuenta interna para recargar cool down
var _cd: float = 0.0
# -------------------------------

## Controlado por signal _on_is_bosting, indica si el special esta activo
var is_on_back_pack_special: bool = false
## si _max_iar_jumps > 0 true
var can_air_jump: bool = false
## Da seguimiento en runtime de cuantos saltos en el aire puede hacer
var current_air_jumps: int = 0


func _ready() -> void:
    set_player()
    set_signals()
    set_stats()


func _physics_process(delta: float) -> void:
    move(delta)
    jump(player.actions['jump'])
    air_jump(player.actions['jump'])
    recharge_cool_down(delta)


func jump(action_button: String) -> void:
    if player.is_on_floor():
        if Input.is_action_just_pressed(action_button):
            player.velocity.y = player._jump_velocity * _jump_mult


func air_jump(action_button: String):
    if player.is_on_floor():
        return
    if not can_air_jump:
        return

    if current_air_jumps > 0:
        if Input.is_action_just_pressed(action_button):
            current_air_jumps -= 1
            player.velocity.y = player._jump_velocity * _jump_mult


## cooldownde air_jump( por ahora, quiero que controle la habilidad especial )
func recharge_cool_down(delta: float) -> void:
    if not can_air_jump:
        return
    
    if current_air_jumps < _max_air_jumps:
        _cd -= delta
        if _cd <= 0.0:
            current_air_jumps += 1
            _cd = _cool_down


func move(delta: float) -> void:
    # no moverse al is_on_back_pack_special(signal de backPack)
    if is_on_back_pack_special:
        return

    # NO MOVERSE EN AIRE
    # if not player.is_on_floor():
    #     return

    var input := player.input
    var direction := (player.transform.basis) * Vector3(
        input.x, 0.0, input.y
    )

    if direction.length() > 0.0:
        direction = direction.normalized()

        var target_velocity := direction * _max_speed

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
    else:
        player.velocity.x = move_toward(
            player.velocity.x,
            0.0,
            _deceleration * delta
        )

        player.velocity.z = move_toward(
            player.velocity.z,
            0.0,
            _deceleration * delta
        )


## Signal desde backPack, usada para bloquear el mivimiento while true
func _on_back_pack_special_state(value) -> void:
    is_on_back_pack_special = value


func set_player() -> void:
    if not owner is Player:
        printerr('owner is not Player class')
        return

    player = owner


## Intencion: pueda usar signals universales en este caso de backpak (por que necesito saber cuando esta activado para bloquear movimiento en este script), y que se encargue de asignar los signals en signals_arr
func set_signals() -> void:
    var mech_addons: Node3D = get_parent()
    for child in mech_addons.get_children():
        if child is BackPack:
            child.connect('back_pack_special_state_signal',_on_back_pack_special_state)
                    

## Referencia Resource LegStats de player en campo leg_stats , para usarlos en campos privados
func set_stats() -> void:
    leg_stats = player.leg_stats
    if not leg_stats is LegStats:
        printerr('LegStats is not LegStats')
        return


    _max_speed = leg_stats.max_speed
    _acceleration = leg_stats.acceleration
    _deceleration = leg_stats.deceleration
    _jump_mult = leg_stats.jump_mult
    _max_air_jumps = leg_stats.max_air_jumps
    _cool_down = leg_stats.cool_down
    _cd = _cool_down

    current_air_jumps = _max_air_jumps

    _type = leg_stats.type


    can_air_jump = true if leg_stats.max_air_jumps > 0 else false
