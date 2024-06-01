extends Node2D

@export var final_screen: Control
@export var focus_element: Control


func _process(_delta):
  if are_all_players_dead() && !final_screen.visible:
    final_screen.show()
    focus_element.grab_focus()

func are_all_players_dead() -> bool:
  for player in get_tree().get_nodes_in_group("players"):
    if !player.is_dead:
      return false
  return true