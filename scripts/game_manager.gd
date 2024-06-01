extends Node2D

enum GameState {TUTORIAL, GAMEPLAY, RESULTS}

@export var tutorial_enemy: EnemyController
@export var enemySpawner: EnemySpawner

@export_subgroup("results", "results")
@export var results_screen: Control
@export var results_focus_element: Control
@export var results_score_label: Label

var game_state: GameState


func _process(_delta):
  match game_state:
    GameState.TUTORIAL:
      if !tutorial_enemy:
        game_state = GameState.GAMEPLAY
        enemySpawner.enabled = true
        # TODO: start tweens to spawn coin pickups
    GameState.GAMEPLAY:
      if are_all_players_dead():
        game_state = GameState.RESULTS
        results_screen.show()
        results_focus_element.grab_focus()
        results_score_label.text = "Final Score: %d!" % ScoreManager.current_score

func are_all_players_dead() -> bool:
  for player in get_tree().get_nodes_in_group("players"):
    if !player.is_dead:
      return false
  return true
