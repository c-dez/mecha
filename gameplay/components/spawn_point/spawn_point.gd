extends MeshInstance3D
class_name SpawnPoint

## Herramienta para indicar la posicion (var spawn_pos:Vector3) y direccion (var look_at_pos:Vector3) en la que el player inicia, y visible = false en ready()


@onready var spawn_pos := global_position
@onready var look_at_pos: Vector3 = $LookAt.global_position

func _ready() -> void:
    visible = false
