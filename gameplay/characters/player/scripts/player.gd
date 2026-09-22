extends CharacterBody3D

class_name Player

## Player


## Recurso con los stats que legs utiliza, nodo Addons/Legs lee estos valores y decide su comportamiento
@export var leg_stats: LegStats
@export var back_pack_stats:BackPackStats
var actions: Dictionary = {
    'jump': 'a_button',
    'back_pack': 'L2_button'
}
## Player input
var input := Vector2.ZERO

# jump _gravity
@export var jump_height: float = 2.0
@export var jump_time_to_peak: float = 0.3
@export var jump_time_to_descend: float = 0.2

var _jump_velocity: float
var _jump_gravity: float
var _jump_fall_gravity: float
####

@export_category("stats")
@export var max_health: int = 10
var current_health: int

@export_category("Camera Sens")
@export var mouse_sens: float = 0.1
@export var gamepad_sens_h: float = 3
@export var gamepad_sens_v: float = 2

func _ready() -> void:
    current_health = max_health
    _calculate_gravity()

    
func _process(_delta: float) -> void:
    input = Input.get_vector("left", "right", "up", "down")

    
func _physics_process(delta: float) -> void:
    _gravity(delta)
    move_and_slide()




func _gravity(delta: float) -> void:
    if not is_on_floor():
        if velocity.y < 0.0:
            velocity.y -= _jump_fall_gravity * delta
        else:
            velocity.y -= _jump_gravity * delta


func _calculate_gravity() -> void:
    _jump_velocity = 2.0 * jump_height / jump_time_to_peak
    _jump_gravity = 2.0 * jump_height / (jump_time_to_peak * jump_time_to_peak)
    _jump_fall_gravity = 2.0 * jump_height / (jump_time_to_descend * jump_time_to_descend)
