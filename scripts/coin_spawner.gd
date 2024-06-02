extends Node2D

@export var coin_pickup_prefab: PackedScene
@export var coin_drop_thresholds: PackedInt32Array = [400, 1000, 1600, 2500, 4000, 8000, 20000]
@export var two_player_spawn_offset: float = 64
@export var extant_coin_spawn_offset: float = 16
@export var empty_bank_mercy_delay: float = 3

@export var fade_when_no_coins: AudioStreamPlayer
@export var fade_when_no_coins_2: AudioStreamPlayer

var next_threshold_index: int = 0
var mercy_tween: Tween

var last_spawned_coins: Array[CoinController]
var last_spawned_coin_y_pos: float


func _ready():
  ScoreManager.score_increased.connect(_on_score_inreased)

func _process(_delta):
  if !_players_have_coins() && !get_tree().get_nodes_in_group("coins"):
    if !mercy_tween || !mercy_tween.is_running():
      mercy_tween = create_tween()
      mercy_tween.tween_interval(empty_bank_mercy_delay)
      mercy_tween.tween_callback(spawn_coin)

    fade_when_no_coins.volume_db = linear_to_db(0)
    fade_when_no_coins_2.volume_db = linear_to_db(0)
  else:
    fade_when_no_coins.volume_db = linear_to_db(1)
    fade_when_no_coins_2.volume_db = linear_to_db(1)


func spawn_coin():
    if _is_last_spawned_coin_untouched():
      last_spawned_coin_y_pos += extant_coin_spawn_offset
    else:
      last_spawned_coin_y_pos = 0

    var coin_pickup = coin_pickup_prefab.instantiate()
    last_spawned_coins = [coin_pickup]
    add_child.call_deferred(coin_pickup)
    coin_pickup.position.y = last_spawned_coin_y_pos

    if PlayerCountSelector.playerCount == 2:
      coin_pickup.position.x = two_player_spawn_offset

      coin_pickup = coin_pickup_prefab.instantiate()
      last_spawned_coins.append(coin_pickup)
      add_child.call_deferred(coin_pickup)
      coin_pickup.position.x = -two_player_spawn_offset
      coin_pickup.position.y = last_spawned_coin_y_pos

func _players_have_coins() -> bool:
  for player in get_tree().get_nodes_in_group("players"):
    if player.coins_held > 0:
      return true
  return false


func _is_last_spawned_coin_untouched() -> bool:
  for coin in last_spawned_coins:
    if is_instance_valid(coin) && coin.position.y == last_spawned_coin_y_pos:
      return true
  return false


func _on_score_inreased(_score_increased: int):
  if next_threshold_index < coin_drop_thresholds.size() && \
      ScoreManager.current_score > coin_drop_thresholds[next_threshold_index]:
    next_threshold_index += 1
    spawn_coin()
