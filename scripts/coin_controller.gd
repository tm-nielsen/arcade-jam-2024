class_name CoinController
extends RigidBody2D

@export var post_collision_damping: float = 0.9
@export var post_collision_angular_damping: float = 2

@export var score_multiplier_increment: float = 1
@export var score_multiplier_label: Label

@export_subgroup("trail", "trail")
@export var trail_line_node: Line2D
@export var trail_frequency: float = 0.05
@export var trail_max_points: int = 12
@export var trail_cutoff_speed: float = 10

@export_subgroup("audio")
@export var wall_bounce_sounds: Array[AudioStream]
@export var enemy_bounce_sounds: Array[AudioStream]
@export var audio_player: AudioStreamPlayer2D

var trail_delay: float = 0
var score_multiplier: float = 1.0

var score_multiplier_label_offset: Vector2
var wall_bounce_count: int
var enemy_bounce_count: int


func _ready():
  linear_damp = 0
  body_entered.connect(_on_body_entered)
  rotation = randf() * 360
  trail_line_node.points = PackedVector2Array()
  score_multiplier_label_offset = score_multiplier_label.position
  score_multiplier_label.top_level = true
  score_multiplier_label.text = ""
  add_to_group("coins")

func _process(delta):
  trail_delay -= delta
  if trail_delay < 0:
    trail_delay += trail_frequency

    add_trail_point()

    if linear_velocity.length() < trail_cutoff_speed:
      trail_line_node.points.remove_at(0)
      score_multiplier = 1
      score_multiplier_label.text = ""

  score_multiplier_label.position = position + score_multiplier_label_offset
    

func add_trail_point():
  var points = trail_line_node.points
  points.push_back(position)
  if points.size() > trail_max_points:
    points.remove_at(0)

  trail_line_node.points = points

func _on_body_entered(body: PhysicsBody2D):
  linear_damp = post_collision_damping
  angular_damp = post_collision_angular_damping
  add_trail_point()

  if body is EnemyController:
    body.recieve_coin_contact(self)
    enemy_bounce_count = _play_sound_from_array(enemy_bounce_sounds, enemy_bounce_count)
  else:
    wall_bounce_count = _play_sound_from_array(wall_bounce_sounds, wall_bounce_count)

  score_multiplier += score_multiplier_increment
  score_multiplier_label.text = "*%d" % score_multiplier

func _play_sound_from_array(sound_array: Array[AudioStream], index: int) -> int:
  var sound = sound_array[index]
  audio_player.stream = sound
  audio_player.play()
  return clampi(index + 1, 0, sound_array.size() - 1)