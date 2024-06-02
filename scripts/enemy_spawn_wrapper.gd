class_name EnemySpawnWrapper
extends Sprite2D

@export var spawn_offset := Vector2(0, -10)
@export var scale_tween_duration: float = 0.4

var enemy_prefab: PackedScene

func initialize(spawn_point: Vector2, enemy_to_spawn: PackedScene):
  position = spawn_point - spawn_offset
  enemy_prefab = enemy_to_spawn

func spawn_enemy():
  var new_enemy = enemy_prefab.instantiate()
  new_enemy.position = position + spawn_offset
  get_parent().add_child(new_enemy)

  new_enemy.scale = Vector2.ZERO
  var size_tween = create_tween()
  size_tween.set_trans(Tween.TRANS_ELASTIC)
  size_tween.set_ease(Tween.EASE_OUT)
  size_tween.tween_property(new_enemy, "scale", Vector2.ONE, scale_tween_duration)