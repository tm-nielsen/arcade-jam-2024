extends Node2D

@export var coin_pickup_prefab: PackedScene
@export var coin_drop_thresholds: PackedInt32Array = [400, 1000, 1600, 2500, 4000, 8000, 20000]
@export var two_player_spawn_offset: float = 64
@export var empty_bank_mercy_delay: float = 2

var next_threshold_index: int = 0
var mercy_tween: Tween


func _ready():
  ScoreManager.score_increased.connect(_on_score_inreased)

func _process(_delta):
  if !_players_have_coins() && !get_tree().get_nodes_in_group("coins") && !mercy_tween:
    mercy_tween = create_tween()
    mercy_tween.tween_interval(empty_bank_mercy_delay)
    mercy_tween.tween_callback(spawn_coin)


func spawn_coin():
    var coin_pickup = coin_pickup_prefab.instantiate()
    add_child.call_deferred(coin_pickup)

    if PlayerCountSelector.playerCount == 2:
      coin_pickup.position.x = two_player_spawn_offset

      coin_pickup = coin_pickup_prefab.instantiate()
      add_child(coin_pickup)
      coin_pickup.position.x = -two_player_spawn_offset

func _players_have_coins() -> bool:
  for player in get_tree().get_nodes_in_group("players"):
    if player.coins_held > 0:
      return true
  return false


func _on_score_inreased(_score_increased: int):
  if next_threshold_index < coin_drop_thresholds.size() && \
      ScoreManager.current_score > coin_drop_thresholds[next_threshold_index]:
    next_threshold_index += 1
    spawn_coin()