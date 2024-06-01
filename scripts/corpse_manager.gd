extends RigidBody2D

@export var score_label: Label
@export var score_size_tween_duration: float = 0.5
@export var score_position_tween_duration: float = 0.4
@export var score_tween_offset: float = -25
@export var lifetime: float = 5.0

@onready var score_label_final_scale := score_label.scale

func initialize(spawn_position, score_value: int, killing_coin: CoinController):
  global_position = spawn_position
  var direction = (position - killing_coin.position).normalized()
  linear_velocity = direction * killing_coin.linear_velocity.length()

  score_label.text = "+%d" % score_value
  score_label.scale = Vector2.ZERO

  var label_size_tween = create_tween()
  label_size_tween.set_trans(Tween.TRANS_BACK)
  label_size_tween.set_ease(Tween.EASE_OUT)
  label_size_tween.tween_property(score_label, "scale", score_label_final_scale, score_size_tween_duration)

  var label_position_tween = create_tween()
  label_position_tween.set_trans(Tween.TRANS_QUAD)
  label_position_tween.tween_property(score_label, "position:y", score_tween_offset, score_position_tween_duration)
