extends Node2D

enum GameState {TUTORIAL, GAMEPLAY, RESULTS}

@export var tutorial_enemy: EnemyController
@export var enemy_spawner: EnemySpawner
@export var tutorial_sprite: Sprite2D
@export var score_display: Label

@export_subgroup("menu references")
@export var background_rect: ColorRect
@export var tutorial_background_color: Color = Color("#1a1d24")
@export var gameplay_background_colour: Color = Color("#2a2d34")

@export_subgroup("results", "results")
@export var results_screen: Control
@export var results_focus_element: Control
@export var results_score_label: Label

var game_state: GameState


func _ready():
  background_rect.color = tutorial_background_color
  score_display.hide()
  tutorial_sprite.show()

func _process(_delta):
  match game_state:
    GameState.TUTORIAL:
      if !tutorial_enemy:
        game_state = GameState.GAMEPLAY
        enemy_spawner.enabled = true
        background_rect.color = gameplay_background_colour
        tutorial_sprite.hide()
        score_display.show()
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
