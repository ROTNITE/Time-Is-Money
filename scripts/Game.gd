# scripts/Game.gd — Autoload Singleton
extends Node
class_name Game

signal time_changed(time_left: float, delta: float)
signal time_ran_out

@export var start_time_seconds: float = 180.0
var time_left: float

func _ready() -> void:
	time_left = start_time_seconds
	emit_signal("time_changed", time_left, 0.0)

func reset_time() -> void:
	time_left = start_time_seconds
	emit_signal("time_changed", time_left, 0.0)

func spend_time(seconds: float) -> void:
	if seconds <= 0.0 or time_left <= 0.0:
		return
	time_left = max(0.0, time_left - seconds)
	emit_signal("time_changed", time_left, -seconds)
	if time_left <= 0.0:
		emit_signal("time_ran_out")

func add_time(seconds: float) -> void:
	if seconds <= 0.0:
		return
	time_left += seconds
	emit_signal("time_changed", time_left, seconds)

func format_mm_ss(t: float) -> String:
	var s := int(round(t))
	var m := s / 60
	var r := s % 60
	return "%02d:%02d" % [m, r]
