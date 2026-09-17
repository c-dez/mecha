extends CharacterBody3D

class_name Player

@export_category('Movement')
@export var move_speed: float = 10.0

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
    pass


func _physics_process(delta: float) -> void:
    _gravity(delta)
    move(move_speed)
    jump("a_button")
    move_and_slide()
    

#----
func move(_speed: float) -> void:
    var input := Input.get_vector("left", "right", "up", "down")
    var direction := (transform.basis * Vector3(input.x, 0, input.y)).normalized()

    velocity.x = direction.x * _speed
    velocity.z = direction.z * _speed


func jump(button_name: String) -> void:
    if is_on_floor():
        if Input.is_action_just_pressed(button_name):
            velocity.y = _jump_velocity


#--private--
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
