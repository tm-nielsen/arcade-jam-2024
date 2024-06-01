extends CoinController

@export var animated_sprite: AnimatedSprite2D
@export var collider: CollisionShape2D

func _ready():
  super()
  collider.disabled = true
  animated_sprite.animation_finished.connect(_on_animation_finished)
  linear_velocity = Vector2.ZERO
  rotation = 0

func _on_animation_finished():
  collider.disabled = false