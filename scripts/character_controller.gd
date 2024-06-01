extends CharacterBody2D

enum PlayerState {IDLE, DASHING, DAMAGED}

@export_range(1, 2) var player_number: int = 1
@export var acceleration: float = 40
@export var movement_speed: float = 200
@export var dash_speed: float = 400
@export var dash_duration: float = 0.5

var state: PlayerState


func _ready():
  if player_number > PlayerCountSelector.playerCount:
    queue_free()

func _physics_process(_delta):
  var input_direction := get_input_direction()

  if input_direction != Vector2.ZERO:
    velocity += acceleration * input_direction
    if velocity.length() > movement_speed:
      velocity = velocity.normalized() * movement_speed
  else:
    velocity = Vector2.ZERO

  move_and_slide()


func get_input_direction() -> Vector2:
  var vertical_input_direction = _get_numbered_input_axis("up", "down")
  var horizontal_input_direction = _get_numbered_input_axis("left", "right")
  return Vector2(horizontal_input_direction, vertical_input_direction).normalized()

func _get_numbered_input_axis(negative_action: String, positive_action: String) -> float:
  var negative_action_name = _get_input_name(negative_action)
  var positive_action_name = _get_input_name(positive_action)
  return Input.get_axis(negative_action_name, positive_action_name)

func _get_input_name(simple_name: String) -> String:
  return ("p%d_" % player_number) + simple_name