class_name Hurtbox
extends Area3D

## Hurtbox detecta hitbox

var health: Node

func _init() -> void:
	# collision_layer = 0
	# collision_mask = 2
	pass
	
func _ready() -> void:
	connect('area_entered', _on_area_entered)
	
	# await owner.ready
	if owner.get_node('Health') == null:
		return
	else:
		health = owner.get_node('Health')


func _on_area_entered(hitbox: Area3D) -> void:
	if not hitbox is Hitbox:
		return

	var h := hitbox as Hitbox
	if health.has_method('take_damage'):
		health.take_damage(h.damage)
