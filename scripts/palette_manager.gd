extends Control

@export var tutorial_palette: Palette
@export var starting_palette: Palette
@export var palettes: Array[Palette]

@export var palette_thresholds: PackedInt32Array = [400, 600, 1000]

var palette_threshold_index: int = 0
var last_palette_threshold: int = 0


func _ready():
  tutorial_palette.apply()
  ScoreManager.score_increased.connect(_on_score_increased)

func _on_score_increased(points_added: int):
  var current_score = ScoreManager.current_score
  if current_score == points_added:
    starting_palette.apply()

  else:
    var distance_from_last_threshold = current_score - last_palette_threshold
    var next_pallette_threshold = palette_thresholds[palette_threshold_index]
    if distance_from_last_threshold > next_pallette_threshold:
      last_palette_threshold = next_pallette_threshold
      palette_threshold_index = clampi(palette_threshold_index + 1, 0, palette_thresholds.size() -1)
      palettes.pick_random().apply()