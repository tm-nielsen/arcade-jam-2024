extends RigidBody2D

@export var score_label: Label
@export var score_size_tween_duration: float = 0.5
@export var score_position_tween_duration: float = 0.4
@export var score_tween_offset: float = -25
@export var lifetime: float = 1.0

@export var sprite: Sprite2D
@export var base_dissolve_material: ShaderMaterial
@export var dissolve_duration: float = 1.5

@onready var score_label_final_scale := score_label.scale
@onready var dissolve_material: ShaderMaterial = base_dissolve_material.duplicate()

func initialize(spawn_position, score_value: int, corpse_texture: Texture2D, killing_coin: CoinController):
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

  score_label.material = dissolve_material
  sprite.material = dissolve_material
  sprite.texture = corpse_texture

  var dissolve_tween = create_tween()
  dissolve_tween.tween_interval(lifetime)
  dissolve_tween.tween_method(_set_dissolve_cutoff, 1.0, 0.0, dissolve_duration)
  dissolve_tween.tween_callback(queue_free)

func _set_dissolve_cutoff(v: float):
  dissolve_material.set_shader_parameter("cutoff", v)