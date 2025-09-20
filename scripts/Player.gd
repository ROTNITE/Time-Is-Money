# scripts/Player.gd — CharacterBody2D with time-per-meter cost
extends CharacterBody2D

@export var speed: float = 220.0
@export var time_per_meter: float = 0.5 # seconds charged per 1 pixel-meter moved

func _physics_process(delta: float) -> void:
	if Game.time_left <= 0.0:
		velocity = Vector2.ZERO
		return

	var dir := Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	).normalized()

	velocity = dir * speed

	var before := global_position
	move_and_slide()
	var after := global_position
	var dist := (after - before).length()

	if dist > 0.0:
		Game.spend_time(dist * time_per_meter)
