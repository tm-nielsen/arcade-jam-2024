class_name EnemyController
extends CharacterBody2D

@export var acceleration: float = 2
@export var damping: float = 0.8
@export var score_value: int = 50
@export var animator: AnimatedSprite2D
@export var corpse_prefab: PackedScene

@export_subgroup("player collision", "player_collision")
@export var player_collision_area: Area2D
@export var player_collision_recoil: float = 300


func _ready():
  animator.speed_scale = 0.95 + randf() * 0.1
  player_collision_area.body_entered.connect(_on_body_entered_player_collision_area)

func _physics_process(delta):
  var target_position = get_closest_player_position()

  var direction = (target_position - position).normalized()
  velocity += direction * acceleration
  velocity *= 1.0 - damping * delta

  animator.flip_h = direction.x > 0
  
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


func recieve_coin_contact(coin: CoinController):
  var corpse = corpse_prefab.instantiate()
  get_parent().add_child.call_deferred(corpse)
  corpse.global_position = global_position
  var direction = (position - coin.position).normalized()
  corpse.linear_velocity = direction * coin.linear_velocity.length()

  queue_free()


func _on_body_entered_player_collision_area(body: PhysicsBody2D):
  if body.has_method("recieve_enemy_contact"):
    body.recieve_enemy_contact(self)
    var direction = (position - body.position).normalized()
    velocity = direction * player_collision_recoil