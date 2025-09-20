# scripts/TimePickup.gd — Area2D that grants +N seconds
extends Area2D

@export var seconds: float = 5.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		Game.add_time(seconds)
		queue_free()
