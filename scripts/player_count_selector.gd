class_name PlayerCountSelector
extends Control

static var playerCount: int = 1

func _ready():
  visible = false

func _process(_delta):
  if visible:
    if playerCount == 1 && Input.is_action_just_pressed("select_2_players"):
      _set_player_count(2)
    if playerCount == 2 && Input.is_action_just_pressed("select_1_player"):
      _set_player_count(1)

  else:
    if (Input.is_action_just_pressed("select_1_player") && playerCount != 1) || \
      (Input.is_action_just_pressed("select_2_players") && playerCount != 2):
      visible = true


func _set_player_count(new_player_count: int):
  playerCount = new_player_count
  RenderingServer.global_shader_parameter_set("player_count", new_player_count)
  GameManager.reload_game()

func _input(event):
  if event.is_action("select_1_player") && playerCount != 1 || \
      event.is_action("select_2_players") && playerCount != 2:
    return
  visible = false