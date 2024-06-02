extends CharacterBody2D

enum PlayerState {NEUTRAL, DASHING, AIMING, THROWING, DAMAGED, DEAD}

@export_range(1, 2) var player_number: int = 1
@export var two_player_colour: Color = Color.WHITE
@export var acceleration: float = 40
@export var movement_speed: float = 200
@export var animator: AnimatedSprite2D
@export var coin_collection_area: Area2D

@export_subgroup("enemy recoil", "enemy_recoil")
@export var enemy_recoil: float = 200
@export var enemy_recoil_damping: float = 3

@export_subgroup("dash", "dash")
@export var dash_initial_acceleration: float = 200
@export var dash_movement_speed: float = 600
@export var dash_timer: Timer
@export var dash_animation_multiplier: float = 1.5

@export_subgroup("throwing")
@export var coin_thrower: CoinThrower
@export var aiming_movement_speed: float = 60

var state: PlayerState
var coins_held: int = 1
var is_dead: get = _get_is_dead


func _ready():
  if player_number > PlayerCountSelector.playerCount:
    queue_free()
  elif PlayerCountSelector.playerCount == 2:
    animator.self_modulate = two_player_colour

  dash_timer.timeout.connect(_on_dash_timer_timeout)
  animator.animation_finished.connect(_on_animation_finished)

  coin_thrower.aiming_started.connect(_on_aiming_started)
  coin_thrower.coin_thrown.connect(_on_coin_thrown)
  coin_thrower.throw_cancelled.connect(_on_coin_throw_cancelled)

  coin_collection_area.body_entered.connect(_on_body_entered_coin_collection_area)


func _physics_process(delta):
  var input_direction := get_numbered_input_direction()
  coin_thrower.process(input_direction, is_numbered_action_pressed("throw"))

  if input_direction != Vector2.ZERO:
    velocity += acceleration * input_direction

    var maximum_speed = get_maximum_speed()
    velocity = _clamp_vector_length(velocity, maximum_speed)

    animator.flip_h = input_direction.x > 0
    if state == PlayerState.NEUTRAL:
      play_numbered_animation("run")

  elif state == PlayerState.DAMAGED:
    velocity *= 1.0 - delta * enemy_recoil_damping
  else:
    velocity = Vector2.ZERO
    if state == PlayerState.NEUTRAL:
      play_numbered_animation("idle")

  if is_numbered_action_just_pressed("dash") && state == PlayerState.NEUTRAL:
    state = PlayerState.DASHING
    animator.speed_scale = dash_animation_multiplier
    play_numbered_animation("run")
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


func recieve_enemy_contact(enemy: EnemyController):
  if state != PlayerState.DAMAGED:
    coin_thrower.disable()
    state = PlayerState.DAMAGED
    coins_held -= 1
    if coins_held >= 0:
      play_numbered_animation("damaged")
    else:
      animator.play("die")
    var direction = (position - enemy.position).normalized()
    velocity = direction * enemy_recoil


func _on_aiming_started():
  state = PlayerState.AIMING
  play_numbered_animation("aim")

func _on_coin_thrown():
  coin_thrower.disable()
  state = PlayerState.THROWING
  play_numbered_animation("throw")
  coins_held -= 1

func _on_coin_throw_cancelled():
  if state == PlayerState.AIMING:
    state = PlayerState.NEUTRAL


func _on_dash_timer_timeout():
  if state == PlayerState.DASHING:
    state = PlayerState.NEUTRAL
    animator.speed_scale = 1
    if coins_held > 0:
      coin_thrower.enable()

func _on_animation_finished():
  if state == PlayerState.THROWING:
    state = PlayerState.NEUTRAL
    if coins_held > 0:
      coin_thrower.enable()
  elif state == PlayerState.DAMAGED:
    state = PlayerState.NEUTRAL
    play_numbered_animation("run")
    if coins_held < 0:
      state = PlayerState.DEAD
      animator.play("ghost_idle")
      collision_layer = 0
    elif coins_held > 0:
      coin_thrower.enable()


func _on_body_entered_coin_collection_area(body: PhysicsBody2D):
  if body is CoinController:
    body.queue_free()
    if (state == PlayerState.DAMAGED && coins_held == -1) || \
        (state == PlayerState.DEAD && !GameManager.is_game_over):
      coins_held = 1
      state = PlayerState.NEUTRAL
      collision_layer = 2
    else:
      coins_held += 1
    if state == PlayerState.NEUTRAL:
      coin_thrower.enable()


func play_numbered_animation(animation_name: String):
  animator.play(animation_name + "_%d" % clampi(coins_held, 0, 3))


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


func _get_is_dead() -> bool:
  return state == PlayerState.DEAD

    
func _clamp_vector_length(v: Vector2, limit: float) -> Vector2:
  if v.length() > limit:
    return v.normalized() * limit
  return v