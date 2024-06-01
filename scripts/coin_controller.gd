extends RigidBody2D

@export var post_collision_damping: float = 5

@export_subgroup("trail", "trail")
@export var trail_line_node: Line2D
@export var trail_frequency: float = 0.05
@export var trail_max_points: int = 12
@export var trail_cutoff_speed: float = 10

var trail_delay: float = 0


func _ready():
  linear_damp = 0
  body_entered.connect(_on_body_entered)
  rotation = randf() * 360
  trail_line_node.points = PackedVector2Array()

func _process(delta):
  trail_delay -= delta
  if trail_delay < 0:
    trail_delay += trail_frequency

    add_trail_point()

    if linear_velocity.length() < trail_cutoff_speed:
      trail_line_node.points.remove_at(0)
    

func add_trail_point():
  var points = trail_line_node.points
  points.push_back(position)
  if points.size() > trail_max_points:
    points.remove_at(0)

  trail_line_node.points = points

func _on_body_entered(_body: PhysicsBody2D):
  linear_damp = post_collision_damping
  add_trail_point()