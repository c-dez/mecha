extends Node3D
## Clase basica de legs contiene multiplicadores para move_speed,jump_speed y special
class_name Legs

## 1.5 = +50%
@export var speed_mult: float = 1.0
@export var jump_mult : float = 1.0


func special_ability():
    print('legs special activated')
    pass