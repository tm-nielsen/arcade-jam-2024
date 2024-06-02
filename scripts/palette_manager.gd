extends Control

@export var tutorial_palette: Palette
@export var starting_palette: Palette
@export var palettes: Array[Palette]

@export var palette_thresholds: PackedInt32Array = [200, 300, 500, 1000]

var palette_threshold_index: int = 0
var last_palette_threshold: int = 0

var palette_override_active: bool
var selected_palette_index = 0


func _ready():
  tutorial_palette.apply()
  ScoreManager.score_increased.connect(_on_score_increased)

func _process(_delta):
  if Input.is_action_just_pressed("toggle_palette_up"):
    _move_palette_selection(1)
  elif Input.is_action_just_pressed("toggle_palette_down"):
    _move_palette_selection(-1)

func _move_palette_selection(increment: int):
  if palette_override_active:
    selected_palette_index = (selected_palette_index + increment) % palettes.size()
    palettes[selected_palette_index].apply()
  else:
    palettes[0].apply()
    palette_override_active = true


func _on_score_increased(points_added: int):
  if palette_override_active:
    return
    
  var current_score = ScoreManager.current_score
  if current_score == points_added:
    starting_palette.apply()

  else:
    var distance_from_last_threshold = current_score - last_palette_threshold
    var next_pallette_threshold = palette_thresholds[palette_threshold_index]
    if distance_from_last_threshold > next_pallette_threshold:
      last_palette_threshold += next_pallette_threshold
      palette_threshold_index = clampi(palette_threshold_index + 1, 0, palette_thresholds.size() -1)
      palettes.pick_random().apply()