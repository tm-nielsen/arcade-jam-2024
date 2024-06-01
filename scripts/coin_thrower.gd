class_name CoinThrower
extends Node2D

signal aiming_started
signal coin_thrown

enum ThrowerState {CAN_THROW, AIMING, DISABLED}

@export var coin_prefab: PackedScene
@export var throw_speed: float = 800
@export var throw_offset: float = 20

var is_aiming: get = get_is_aiming
var state: ThrowerState


func process(input_direction: Vector2, is_throw_pressed: bool):
  if is_throw_pressed:
    if state == ThrowerState.CAN_THROW:
      state = ThrowerState.AIMING
      aiming_started.emit()

  elif state == ThrowerState.AIMING && input_direction:
    throw_coin(input_direction)
  elif state == ThrowerState.AIMING:
    state = ThrowerState.CAN_THROW

func throw_coin(direction: Vector2):
  var new_coin: RigidBody2D = coin_prefab.instantiate()

  new_coin.top_level = true
  new_coin.position = global_position + direction * throw_offset;
  new_coin.linear_velocity = direction * throw_speed

  add_child(new_coin)
  
  state = ThrowerState.CAN_THROW
  coin_thrown.emit()


func get_is_aiming() -> bool:
  return state == ThrowerState.AIMING

func disable():
  state = ThrowerState.DISABLED

func enable():
  state = ThrowerState.CAN_THROW