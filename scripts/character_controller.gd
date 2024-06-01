extends CharacterBody2D

enum PlayerState {NEUTRAL, DASHING, THROWING, DAMAGED}

@export_range(1, 2) var player_number: int = 1
@export var acceleration: float = 40
@export var movement_speed: float = 200

@export_subgroup("dash", "dash")
@export var dash_initial_acceleration: float = 200
@export var dash_movement_speed: float = 600
@export var dash_timer: Timer

@export_subgroup("throwing")
@export var coin_thrower: CoinThrower
@export var aiming_movement_speed: float = 60

var state: PlayerState


func _ready():
  if player_number > PlayerCountSelector.playerCount:
    queue_free()
  dash_timer.timeout.connect(_on_dash_timer_timeout)
  coin_thrower.aiming_started.connect(_on_aiming_started)
  coin_thrower.coin_thrown.connect(_on_coin_thrown)


func _physics_process(_delta):
  var input_direction := get_numbered_input_direction()
  coin_thrower.process(input_direction, is_numbered_action_pressed("throw"))

  if input_direction != Vector2.ZERO:
    velocity += acceleration * input_direction

    var maximum_speed = get_maximum_speed()
    velocity = _clamp_vector_length(velocity, maximum_speed)
  else:
    velocity = Vector2.ZERO

  if is_numbered_action_just_pressed("dash") && state == PlayerState.NEUTRAL:
    state = PlayerState.DASHING
    coin_thrower.disable()
    velocity += input_direction * dash_initial_acceleration
    dash_timer.start()

  move_and_slide()


func get_maximum_speed() -> float:
  if coin_thrower.is_aiming:
    return aiming_movement_speed
  if state == PlayerState.DASHING:
    return dash_movement_speed
  return movement_speed


func _on_aiming_started():
  pass

func _on_coin_thrown():
  pass


func _on_dash_timer_timeout():
  if state == PlayerState.DASHING:
    state = PlayerState.NEUTRAL
    coin_thrower.enable()


func get_numbered_input_direction() -> Vector2:
  var vertical_input_direction = _get_numbered_input_axis("up", "down")
  var horizontal_input_direction = _get_numbered_input_axis("left", "right")
  return Vector2(horizontal_input_direction, vertical_input_direction).normalized()

func is_numbered_action_just_pressed(simple_name: String) -> bool:
  return Input.is_action_just_pressed(_get_input_name(simple_name))

func is_numbered_action_pressed(simple_name: String) -> bool:
  return Input.is_action_pressed(_get_input_name(simple_name))

func _get_numbered_input_axis(negative_action: String, positive_action: String) -> float:
  var negative_action_name = _get_input_name(negative_action)
  var positive_action_name = _get_input_name(positive_action)
  return Input.get_axis(negative_action_name, positive_action_name)

func _get_input_name(simple_name: String) -> String:
  return ("p%d_" % player_number) + simple_name

    
func _clamp_vector_length(v: Vector2, limit: float) -> Vector2:
  if v.length() > limit:
    return v.normalized() * limit
  return v