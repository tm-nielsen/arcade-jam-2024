extends RigidBody2D

@export var post_collision_damping: float = 5

func _ready():
  linear_damp = 0
  body_entered.connect(_on_body_entered)

func _on_body_entered(_body: PhysicsBody2D):
  linear_damp = post_collision_damping