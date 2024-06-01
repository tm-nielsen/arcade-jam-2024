class_name EnemySpawner
extends Node2D

@export var spawn_area := Vector2(400, 200)
@export var player_safety_margin : float = 80

@export_subgroup("references")
@export var bird_prefab: PackedScene

var enabled: bool = false
var timer: float = 0


func _process(delta):
  if !enabled: return

  timer += delta

  var spawn_period = 2.5 - log(timer)
  if timer > spawn_period:
    spawn_enemy()
    timer -= spawn_period

func spawn_enemy():
  var new_enemy = bird_prefab.instantiate()
  add_child(new_enemy)
  new_enemy.position = _get_spawn_position()

func _get_spawn_position() -> Vector2:
  var random_spawn_position = _get_random_spawn_position()
  while _is_point_too_close_to_player(random_spawn_position):
    random_spawn_position = _get_random_spawn_position()
  return random_spawn_position

func _is_point_too_close_to_player(point: Vector2) -> bool:
  for player in get_tree().get_nodes_in_group("players"):
    if point.distance_to(player.position) < player_safety_margin:
      return true
  return false

func _get_random_spawn_position() -> Vector2:
  var spawn_position = Vector2()
  spawn_position.x = _get_random_point_in_span(spawn_area.x)
  spawn_position.y = _get_random_point_in_span(spawn_area.y)
  return spawn_position

func _get_random_point_in_span(length: float) -> float:
  return (2 * randf() - 1) * length / 2