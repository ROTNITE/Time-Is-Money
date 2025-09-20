# scripts/Player.gd (фрагмент интеграции Dash)
extends CharacterBody2D

@export var speed: float = 220.0
@export var time_per_meter: float = 0.5

@onready var dash: Node = $Dash

func _physics_process(delta: float) -> void:
	if Game.time_left <= 0.0:
		velocity = Vector2.ZERO
		return

	var dir := Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	).normalized()

	# Запрос рывка
	if Input.is_action_just_pressed("dash") and dash:
		dash.try_dash(dir)

	# Базовая скорость
	var base_vel := dir * speed
	# Пусть Dash приоритетно задаёт скорость, если активен
	if dash:
		velocity = dash.apply_to_velocity(base_vel)
	else:
		velocity = base_vel

	var before := global_position
	move_and_slide()
	var after := global_position
	var dist := (after - before).length()
	if dist > 0.0:
		Game.spend_time(dist * time_per_meter)
