extends Control

@export var tutorial_pallette: Pallette
@export var starting_pallette: Pallette
@export var pallettes: Array[Pallette]

@export var pallette_thresholds: PackedInt32Array = [400, 600, 1000]

var pallette_threshold_index: int = 0
var last_pallette_threshold: int = 0


func _ready():
  tutorial_pallette.apply()
  ScoreManager.score_increased.connect(_on_score_increased)

func _on_score_increased(points_added: int):
  var current_score = ScoreManager.current_score
  if current_score == points_added:
    starting_pallette.apply()

  else:
    var distance_from_last_threshold = current_score - last_pallette_threshold
    var next_pallette_threshold = pallette_thresholds[pallette_threshold_index]
    if distance_from_last_threshold > next_pallette_threshold:
      last_pallette_threshold = next_pallette_threshold
      pallette_threshold_index = clampi(pallette_threshold_index + 1, 0, pallette_thresholds.size() -1)
      pallettes.pick_random().apply()