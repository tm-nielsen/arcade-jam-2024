class_name EnemySpawner
extends Node2D

@export var spawn_area := Vector2(400, 200)

@export_subgroup("references")
@export var bird_prefab: PackedScene

var enabled: bool = false
var timer: float = 0


func _process(delta):
  if !enabled: return

  timer += delta

  var spawn_period = 4 * (2.5 - log(timer))
  if timer > spawn_period:
    spawn_enemy()
    timer -= spawn_period

func spawn_enemy():
  var new_enemy = bird_prefab.instantiate()
  add_child(new_enemy)
  new_enemy.position = _get_spawn_position()

func _get_spawn_position() -> Vector2:
  var spawn_position = Vector2()
  spawn_position.x = _get_random_point_in_span(spawn_area.x)
  spawn_position.y = _get_random_point_in_span(spawn_area.y)
  return spawn_position

func _get_random_point_in_span(length: float) -> float:
  return (2 * randf() - 1) * length / 2