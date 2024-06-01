extends Label

@export var count_tween_duration: float = 0.4
@export var size_tween_scale: float = 1.1
@export var size_tween_grow_duration: float = 0.2
@export var size_tween_shrink_duration: float = 0.3

@onready var base_scale = scale

var displayed_score: int = 0

var count_tween: Tween
var size_tween: Tween

func _ready():
  ScoreManager.score_added.connect(_on_score_added)
  text = "00"

func _on_score_added(_points: int):
  if count_tween:
    count_tween.kill()
  if size_tween:
    size_tween.kill()

  count_tween = create_tween()
  count_tween.set_trans(Tween.TRANS_EXPO)
  count_tween.set_ease(Tween.EASE_OUT)
  count_tween.tween_method(_set_display_score, displayed_score, ScoreManager.current_score, count_tween_duration)

  size_tween = create_tween()
  size_tween.set_trans(Tween.TRANS_BACK)
  size_tween.tween_property(self, "scale", size_tween_scale * base_scale, size_tween_grow_duration)
  size_tween.tween_property(self, "scale", base_scale, size_tween_shrink_duration)


func _set_display_score(score: int):
  displayed_score = score
  text = str(score)