extends Resource
class_name LegStats


@export var type := TYPE.basic
@export var max_speed: float = 15
@export var acceleration: float = 20.0
@export var deceleration: float = 50.0
@export_category('can_air_jump')
@export var jump_mult: float = 1.5
@export var max_air_jumps: int = 3
@export var cool_down: float = 3.0


enum TYPE {
    basic,
    aerial
}
