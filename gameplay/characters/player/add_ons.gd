extends Node3D


class_name PlayerAddOns

## obtiene las propiedades de sus hijos para pasarlas a owner

func _ready() -> void:
    set_legs_propeties()
    pass


func set_legs_propeties():
    for child in get_children():
        if child is Legs:
            var player:Player = owner

            player.speed_mult = child.speed_mult
            player.jump_mult = child.jump_mult
            player.special = child.special_ability()




    pass

