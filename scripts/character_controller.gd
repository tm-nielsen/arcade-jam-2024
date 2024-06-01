extends CharacterBody2D

enum PlayerState {NEUTRAL, DASHING, AIMING, THROWING, DAMAGED}

@export_range(1, 2) var player_number: int = 1
@export var two_player_colour: Color = Color.WHITE
@export var acceleration: float = 40
@export var movement_speed: float = 200
@export var animator: AnimatedSprite2D

@export_subgroup("dash", "dash")
@export var dash_initial_acceleration: float = 200
@export var dash_movement_speed: float = 600
@export var dash_timer: Timer
@export var dash_animation_multiplier: float = 1.5

@export_subgroup("throwing")
@export var coin_thrower: CoinThrower
@export var aiming_movement_speed: float = 60

var state: PlayerState


func _ready():
  if player_number > PlayerCountSelector.playerCount:
    queue_free()
  elif PlayerCountSelector.playerCount == 2:
    animator.self_modulate = two_player_colour

  dash_timer.timeout.connect(_on_dash_timer_timeout)
  coin_thrower.aiming_started.connect(_on_aiming_started)
  coin_thrower.coin_thrown.connect(_on_coin_thrown)
  coin_thrower.throw_cancelled.connect(_on_coin_throw_cancelled)
  animator.animation_finished.connect(_on_animation_finished)


func _physics_process(_delta):
  var input_direction := get_numbered_input_direction()
  coin_thrower.process(input_direction, is_numbered_action_pressed("throw"))

  if input_direction != Vector2.ZERO:
    velocity += acceleration * input_direction

    var maximum_speed = get_maximum_speed()
    velocity = _clamp_vector_length(velocity, maximum_speed)

    animator.flip_h = input_direction.x > 0
    if state == PlayerState.NEUTRAL:
      animator.play("run")

  else:
    velocity = Vector2.ZERO
    if state == PlayerState.NEUTRAL:
      animator.play("idle")

  if is_numbered_action_just_pressed("dash") && state == PlayerState.NEUTRAL:
    state = PlayerState.DASHING
    animator.speed_scale = dash_animation_multiplier
    animator.play("run")
    coin_thrower.disable()
    velocity += input_direction * dash_initial_acceleration
    dash_timer.start()

  move_and_slide()


func get_maximum_speed() -> float:
  match state:
    PlayerState.AIMING:
      return aiming_movement_speed
    PlayerState.THROWING:
      return 0
    PlayerState.DASHING:
      return dash_movement_speed
  return movement_speed


func _on_aiming_started():
  state = PlayerState.AIMING
  animator.play("aim")

func _on_coin_thrown():
  coin_thrower.disable()
  state = PlayerState.THROWING
  animator.play("throw")

func _on_coin_throw_cancelled():
  if state == PlayerState.AIMING:
    state = PlayerState.NEUTRAL


func _on_dash_timer_timeout():
  if state == PlayerState.DASHING:
    state = PlayerState.NEUTRAL
    animator.speed_scale = 1
    coin_thrower.enable()

func _on_animation_finished():
  if state == PlayerState.THROWING:
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