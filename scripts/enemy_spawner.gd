class_name EnemySpawner
extends Node2D

@export var spawn_area := Vector2(400, 200)
@export var player_safety_margin: float = 80
# @export var two_player_spawn_multiplier: float = 1.6
# @export var duck_spawn_threshold: int = 1000

@export_subgroup("references")
@export var spawn_wrapper_prefab: PackedScene
@export var enemy_type_timers: Array[EnemyTypeSpawnTimer]
# @export var basic_enemy_prefab: PackedScene
# @export var duck_prefab: PackedScene

var enabled: bool = false
# var timer: float = 0

func _ready():
  for type_timer in enemy_type_timers:
    type_timer.connect_signals(spawn_enemy)

func _process(delta):
  if !enabled: return

  for type_timer in enemy_type_timers:
    type_timer.process(delta)


func spawn_enemy(enemy_prefab):
  var spawn_wrapper = spawn_wrapper_prefab.instantiate()
  add_child(spawn_wrapper)
  spawn_wrapper.initialize(_get_spawn_position(), enemy_prefab)


func _get_spawn_position() -> Vector2:
  var random_spawn_position = get_random_spawn_position()
  while _is_point_too_close_to_player(random_spawn_position):
    random_spawn_position = get_random_spawn_position()
  return random_spawn_position

func _is_point_too_close_to_player(point: Vector2) -> bool:
  for player in get_tree().get_nodes_in_group("players"):
    if point.distance_to(player.position) < player_safety_margin:
      return true
  return false

func get_random_spawn_position() -> Vector2:
  var spawn_position = Vector2()
  spawn_position.x = _get_random_point_in_span(spawn_area.x)
  spawn_position.y = _get_random_point_in_span(spawn_area.y)
  return spawn_position

func _get_random_point_in_span(length: float) -> float:
  return (2 * randf() - 1) * length / 2
