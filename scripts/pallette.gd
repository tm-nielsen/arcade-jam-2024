class_name Pallette
extends Resource

@export var player_colour: Color = Color.WHITE
@export var enemy_colour: Color = Color.WHITE
@export var black_colour: Color = Color.BLACK
@export var accent_colour: Color = Color.GRAY
@export var background_colour: Color = Color.DARK_GRAY

func apply():
  RenderingServer.global_shader_parameter_set("player_colour", player_colour)
  RenderingServer.global_shader_parameter_set("enemy_colour", enemy_colour)
  RenderingServer.global_shader_parameter_set("black_colour", black_colour)
  RenderingServer.global_shader_parameter_set("accent_colour", accent_colour)
  RenderingServer.global_shader_parameter_set("background_colour", background_colour)