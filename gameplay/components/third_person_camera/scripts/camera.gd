extends SpringArm3D


## third person camera sensibilidad en player


@onready var player: Player = owner
# clamp vertical
@onready var max_rad := deg_to_rad(50)
@onready var min_rad := deg_to_rad(-70)


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(_delta: float) -> void:
	_gamepad_camera_rotation()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.relative:
			_mouse_camera_rotation(event)


## mover la camara con el mouse
func _mouse_camera_rotation(event) -> void:
	# rotates horizontal
	player.rotate_y(deg_to_rad(-event.relative.x * player.mouse_sens))

	# rotates vertical
	rotate_x(deg_to_rad(-event.relative.y * player.mouse_sens))
	rotation.x = clamp(rotation.x, min_rad, max_rad)

	rotation.z = clamp(rotation.z, 0, 0)


func _gamepad_camera_rotation() -> void:
	#gamepad camera
	#horizontal
	var axis := Input.get_vector('RStick_left', 'RStick_right', 'RStick_up', 'RStick_down')

	if axis.length() > 0.2:
		# horizontal
		player.rotate_y(deg_to_rad(-axis.x * player.gamepad_sens_h))
		#vertical
		rotate_x(deg_to_rad(-axis.y * player.gamepad_sens_v))

		#clamp
		rotation.x = clamp(rotation.x, min_rad, max_rad)
		rotation.z = clamp(rotation.z, 0, 0)