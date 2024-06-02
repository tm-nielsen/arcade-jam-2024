class_name EnemyTypeSpawnTimer
extends Resource

signal spawn_delay_timeout(prefab: PackedScene)

@export var enemy_prefab: PackedScene
@export var score_threshold: int = 0
@export var spawn_delay_multiplier: float = 1
@export var two_player_spawn_multiplier: float = 1.6

var first_unit_spawned: bool
var timer: float


func connect_signals(spawn_function: Callable):
  spawn_delay_timeout.connect(spawn_function)
  ScoreManager.score_increased.connect(_on_score_increased)

func process(delta):
  if ScoreManager.current_score > score_threshold:
    timer += delta

    var spawn_period = _get_spawn_period()
    if timer > spawn_period:
      timer -= spawn_period
      spawn_delay_timeout.emit(enemy_prefab)

func _get_spawn_period() -> float:
  var spawn_period = 2.5 - log(timer / spawn_delay_multiplier)
  if PlayerCountSelector.playerCount == 2:
    spawn_period /= two_player_spawn_multiplier
  return spawn_period * spawn_delay_multiplier


func _on_score_increased(_points_added: int):
  if !first_unit_spawned && ScoreManager.current_score > score_threshold:
    spawn_delay_timeout.emit(enemy_prefab)
    first_unit_spawned = true