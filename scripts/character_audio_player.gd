class_name CharacterAudioPlayer
extends AudioStreamPlayer2D

@export var dash_sound: AudioStream
@export var hurt_sound: AudioStream
@export var aim_sound: AudioStream
@export var throw_sound: AudioStream
@export var coin_collected_sound: AudioStream


func play_dash_sound():
  _play_sound(dash_sound)

func play_hurt_sound():
  _play_sound(hurt_sound)

func play_aim_sound():
  _play_sound(aim_sound)

func play_throw_sound():
  _play_sound(throw_sound)

func play_coin_collected_sound():
  _play_sound(coin_collected_sound)

func _play_sound(sound: AudioStream):
  stream = sound
  play()