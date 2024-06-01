class_name EnemyController
extends CharacterBody2D

@export var acceleration: float = 2
@export var damping: float = 0.8
@export var score_value: int = 50


func _physics_process(delta):
  var target_position = get_closest_player_position()

  var direction = (target_position - position).normalized()
  velocity += direction * acceleration
  velocity *= 1.0 - damping * delta
  
  move_and_slide()


func get_closest_player_position() -> Vector2:
  var players = get_tree().get_nodes_in_group("players")

  var closest_position = players[0].position
  var distance_to_closest_player = position.distance_squared_to(closest_position)

  for player in players:
    var distance_to_player = position.distance_squared_to(player.position)
    if distance_to_player < distance_to_closest_player:
      distance_to_closest_player = distance_to_player
      closest_position = player.position

  return closest_position


func on_coin_hit(score_multiplier: float):
  # TODO: add corpse / 
  queue_free()