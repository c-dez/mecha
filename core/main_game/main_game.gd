extends Node3D
class_name MainGame

## Escena root de el juego, se encarga de contener todas las escenas que componen el juego (world, player, ui, etc)


@onready var level_root: Node3D = get_node('World/LevelRoot')
@onready var entity_root: Node3D = get_node('World/EntityRoot')


func _ready() -> void:
	load_player()
	load_level(ScenePaths.TEST_LEVELS["level_1"])


func load_level(_level_path: String) -> void:
	var level: PackedScene = load(_level_path)
	var l := level.instantiate()
	level_root.add_child(l)
	var spawn: SpawnPoint = l.get_node('SpawnPoint')
	spawn_player(spawn)


func load_player() -> void:
	var player: PackedScene = load(ScenePaths.PLAYER)
	var p := player.instantiate()
	entity_root.add_child(p)


func spawn_player(spawn: SpawnPoint) -> void:
	var player: Player = get_tree().get_first_node_in_group('player')
	player.global_position = spawn.spawn_pos
	player.look_at(spawn.look_at_pos)
