extends Resource
class_name LegStats

## Recurso con stats para legs (res://gameplay/addons/legs/legs_basic/resource_script/leg_stats_script.gd)

## tipo de legs ( tal vez no lo necesite)
@export var type := TYPE.basic
@export var max_speed: float = 15
@export var acceleration: float = 20.0
@export var deceleration: float = 50.0

@export_category('can_air_jump')
## Multiplicador de jump_force
@export var jump_mult: float = 1.5
## numero de saltos en el aire, si es cero, entonces no puede saltar en el aire
@export var max_air_jumps: int = 3
## Cool down de habilidad en segundos (por ahora solo es para air_jump)
@export var cool_down: float = 3.0

enum TYPE {
    ## piernas base
    basic,
    ## piernas con capacidad de hacer algo en el aire
    aerial
}
