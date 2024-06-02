extends Node

signal score_increased(points: int)

var score_locked: bool = false
var current_score: int = 0


func add_score(points: int):
  if score_locked:
    return

  current_score += points
  score_increased.emit(points)

func lock_score():
  score_locked = true

func reset_score():
  current_score = 0
  score_locked = false