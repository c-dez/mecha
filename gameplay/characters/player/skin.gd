extends MeshInstance3D

func _physics_process(_delta: float) -> void:
    # rotate_skin()
    # skin_pos()
    pass

    
## rotar skin hacia direccion  que mira player si se mueve
func rotate_skin() ->void:
    var input := Input.get_vector("left", "right", "up", "down")
    if input:
        rotation.y = owner.rotation.y

    pass

func skin_pos():
    # self top_level = true
    # tiene que seguir la pos de Player
    global_position = owner.global_position

    pass
    