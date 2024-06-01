extends Node

signal score_added(points: int)

var current_score: int = 0


func add_score(points: int):
  current_score += points
  score_added.emit(points)

func reset_score():
  current_score = 0