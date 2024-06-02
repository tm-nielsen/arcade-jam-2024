extends Node2D

@export var score_thresholds: Array[int] = [3000, 4000, 6000, 8000]
@export var offset := Vector2(285, 180)
@export var tween_starting_offset := Vector2(335, 230)
@export var move_tween_duration: float = 0.8
@export var bumper_prefab: PackedScene

var threshold_index: int
var remaining_corners := [Vector2(1, 1), Vector2(1, -1), Vector2(-1, -1), Vector2(-1, 1)]


func _ready():
  ScoreManager.score_increased.connect(_on_score_increased)

func _on_score_increased(_points_added: int):
  if threshold_index < score_thresholds.size() && \
      ScoreManager.current_score > score_thresholds[threshold_index]:
    threshold_index += 1
    
    var corner = remaining_corners.pick_random()
    remaining_corners.erase(corner)

    var bumper = bumper_prefab.instantiate()
    bumper.position = tween_starting_offset * corner
    add_child.call_deferred(bumper)

    var move_tween = create_tween()
    move_tween.set_trans(Tween.TRANS_BACK)
    move_tween.set_ease(Tween.EASE_OUT)
    move_tween.tween_property(bumper, "position", offset * corner, move_tween_duration)