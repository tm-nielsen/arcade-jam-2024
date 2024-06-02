extends EnemyController

enum HungerState {HUNGRY, EATING, FED}

@export var coin_detection_area: Area2D
@export var coin_collection_area: Area2D
@export var coin_detected_acceleration: float = 20
@export var coin_pickup_prefab: PackedScene
@export var target_reached_threshold: float = 20

@export var eat_sound_player: AudioStreamPlayer2D

var state: HungerState
var target_coin: CoinController = null
var target_position: Vector2


func _ready():
  player_collision_area.body_entered.connect(_on_body_entered_player_collision_area)
  coin_detection_area.body_entered.connect(_on_body_entered_coin_detection_area)
  coin_detection_area.body_exited.connect(_on_body_exited_coin_detection_area)
  coin_collection_area.body_entered.connect(_on_body_entered_coin_collection_area)
  animator.animation_finished.connect(_on_animation_finished)
  target_position = get_parent().get_random_spawn_position()


func _physics_process(delta):
  if is_instance_valid(target_coin):
    target_position = target_coin.position
    accelerate_towards_target(target_position, coin_detected_acceleration, delta)
  else:
    accelerate_towards_target(target_position, acceleration, delta)

  if position.distance_to(target_position) < target_reached_threshold:
    target_position = get_parent().get_random_spawn_position()

  move_and_slide()


func receive_coin_contact(coin: CoinController):
  if state == HungerState.FED:
    super(coin)
    var dropped_coin = coin_pickup_prefab.instantiate()
    dropped_coin.position = position
    get_parent().add_child.call_deferred(dropped_coin)
  else:
    eat_coin(coin)


func eat_coin(coin: CoinController):
  coin.queue_free()
  target_coin = null
  state = HungerState.EATING
  animator.play("eat")
  eat_sound_player.play()
  _disable_coin_monitoring.call_deferred()


func _on_body_entered_coin_detection_area(body: PhysicsBody2D):
  if body is CoinController && !is_instance_valid(target_coin):
    target_coin = body
    animator.play("run")

func _on_body_exited_coin_detection_area(body: PhysicsBody2D):
  if body == target_coin:
    target_coin = null
    animator.play("walk")

func _on_body_entered_coin_collection_area(body: PhysicsBody2D):
  if body is CoinController && state == HungerState.HUNGRY:
    eat_coin(body)

func _disable_coin_monitoring():
    coin_detection_area.monitoring = false
    coin_collection_area.monitoring = false


func _on_animation_finished():
  if state == HungerState.EATING:
    state = HungerState.FED
    animator.play("walk_eaten")
