extends Control

@export var reset_button: Button
@export var quit_button: Button


func _ready():
  visible = false
  get_tree().paused = false
  visibility_changed.connect(_on_visibility_changed)
  reset_button.pressed.connect(reset_game)
  quit_button.pressed.connect(quit_game)

func _process(_delta):
  if Input.is_action_just_pressed("pause"):
    visible = !visible

  if visible && !reset_button.has_focus() && !quit_button.has_focus():
    reset_button.grab_focus()

func _on_visibility_changed():
  get_tree().paused = visible
  reset_button.grab_focus()

func reset_game():
  get_tree().reload_current_scene()

func quit_game():
  get_tree().quit()
