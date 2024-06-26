class_name GameManager
extends Node2D

enum GameState {TUTORIAL, GAMEPLAY, RESULTS}

@export var tutorial_enemy: EnemyController
@export var enemy_spawner: EnemySpawner
@export var tutorial_sprite: AnimatedSprite2D
@export var score_display: Label

@export_subgroup("menu references")
@export var background_rect: ColorRect
@export var tutorial_background_color: Color = Color("#1a1d24")
@export var gameplay_background_colour: Color = Color("#2a2d34")

@export_subgroup("results", "results")
@export var results_screen: Control
@export var results_focus_element: Control
@export var results_score_label: Label

@export_subgroup("music")
@export var drums_intro: AudioStreamPlayer
@export var melody_intro: AudioStreamPlayer
@export var drums_loop: AudioStreamPlayer
@export var melody_loop: AudioStreamPlayer

static var instance
static var is_game_over: get = _get_is_game_over
var game_state: GameState


func _ready():
  instance = self
  Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
  background_rect.color = tutorial_background_color
  score_display.hide()
  tutorial_sprite.show()
  melody_intro.finished.connect(_on_melody_intro_finished)


func _on_melody_intro_finished():
  drums_loop.play()
  melody_loop.play()

func _process(_delta):
  match game_state:
    GameState.TUTORIAL:
      if !tutorial_enemy:
        game_state = GameState.GAMEPLAY
        drums_intro.play()
        melody_intro.play()
        enemy_spawner.enabled = true
        background_rect.color = gameplay_background_colour
        tutorial_sprite.hide()
        score_display.show()
    GameState.GAMEPLAY:
      if are_all_players_dead():
        game_state = GameState.RESULTS
        drums_intro.stop()
        melody_intro.stop()
        drums_loop.stop()
        melody_loop.stop()
        ScoreManager.lock_score()
        results_screen.show()
        results_focus_element.grab_focus()
        results_score_label.text = "Final Score: %d!" % ScoreManager.current_score

func are_all_players_dead() -> bool:
  for player in get_tree().get_nodes_in_group("players"):
    if !player.is_dead:
      return false
  return true

static func reload_game():
  ScoreManager.reset_score()
  instance.get_tree().reload_current_scene()

static func _get_is_game_over() -> bool:
  return instance.game_state == GameState.RESULTS
