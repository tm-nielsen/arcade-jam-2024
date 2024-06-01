class_name PlayerCountSelector
extends Control

static var playerCount: int = 1

func _ready():
  visible = false

func _process(_delta):
  if visible:
    if playerCount == 1 && Input.is_action_just_pressed("select_2_players"):
      playerCount = 2
      get_tree().reload_current_scene()
    if playerCount == 2 && Input.is_action_just_pressed("select_1_player"):
      playerCount = 1
      get_tree().reload_current_scene()

  else:
    if (Input.is_action_just_pressed("select_1_player") && playerCount != 1) || \
      (Input.is_action_just_pressed("select_2_players") && playerCount != 2):
      visible = true


func _input(event):
  if event.is_action("select_1_player") || event.is_action("select_2_players"):
    return
  visible = false