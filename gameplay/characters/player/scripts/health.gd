extends Node


## se encarga de la vida de el owner y ejecuta las acciones necesarias de vida

@onready var _player: Player = owner


func take_damage(damage: int) -> void:
    _player.current_health -= damage
    print(_player.current_health)
    if _player.current_health < 1:
        die()

func take_heal(heal: int) -> void:
    _player.current_health += heal


    
func die() -> void:
    print('player dies')