extends Node2D

@export var coin_pickup_prefab: PackedScene
@export var coin_drop_thresholds: PackedInt32Array = [400, 1000, 1600, 2500, 4000, 8000, 20000]
@export var two_player_spawn_offset: float = 64

var next_threshold_index: int = 0


func _ready():
  ScoreManager.score_increased.connect(_on_score_inreased)

func _on_score_inreased(_score_increased: int):
  if next_threshold_index < coin_drop_thresholds.size() && \
      ScoreManager.current_score > coin_drop_thresholds[next_threshold_index]:
    next_threshold_index += 1
    
    var coin_pickup = coin_pickup_prefab.instantiate()
    add_child.call_deferred(coin_pickup)

    if PlayerCountSelector.playerCount == 2:
      coin_pickup.position.x = two_player_spawn_offset

      coin_pickup = coin_pickup_prefab.instantiate()
      add_child(coin_pickup)
      coin_pickup.position.x = -two_player_spawn_offset