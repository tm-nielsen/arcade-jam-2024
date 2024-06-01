extends CharacterBody2D

enum PlayerState {NEUTRAL, DASHING, DAMAGED}

@export_range(1, 2) var player_number: int = 1
@export var acceleration: float = 40
@export var movement_speed: float = 200
@export var dash_initial_acceleration: float = 200
@export var dash_speed: float = 600
@export var dash_timer: Timer

var state: PlayerState


func _ready():
  if player_number > PlayerCountSelector.playerCount:
    queue_free()
  dash_timer.timeout.connect(_on_dash_timer_timeout)


func _physics_process(_delta):
  var input_direction := get_input_direction()

  if input_direction != Vector2.ZERO:
    velocity += acceleration * input_direction

    var maximum_speed = dash_speed if state == PlayerState.DASHING else movement_speed
    velocity = _clamp_vector_length(velocity, maximum_speed)
  else:
    velocity = Vector2.ZERO

  if is_numbered_action_just_pressed("dash") && state == PlayerState.NEUTRAL:
    state = PlayerState.DASHING
    velocity += input_direction * dash_initial_acceleration
    dash_timer.start()

  move_and_slide()


func _clamp_vector_length(v: Vector2, limit: float) -> Vector2:
  if v.length() > limit:
    return v.normalized() * limit
  return v


func get_input_direction() -> Vector2:
  var vertical_input_direction = _get_numbered_input_axis("up", "down")
  var horizontal_input_direction = _get_numbered_input_axis("left", "right")
  return Vector2(horizontal_input_direction, vertical_input_direction).normalized()

func is_numbered_action_just_pressed(simple_name: String) -> bool:
  return Input.is_action_just_pressed(_get_input_name(simple_name))

func _get_numbered_input_axis(negative_action: String, positive_action: String) -> float:
  var negative_action_name = _get_input_name(negative_action)
  var positive_action_name = _get_input_name(positive_action)
  return Input.get_axis(negative_action_name, positive_action_name)

func _get_input_name(simple_name: String) -> String:
  return ("p%d_" % player_number) + simple_name


func _on_dash_timer_timeout():
  if state == PlayerState.DASHING:
    state = PlayerState.NEUTRAL