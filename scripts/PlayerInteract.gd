# scripts/PlayerInteract.gd — простая интеракция по кнопке "interact"
extends Area2D
class_name PlayerInteract

@export var action_name: StringName = &"interact"  # добавь действие в Input Map
@export var max_distance: float = 96.0             # на всякий, отсечка радиуса

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(action_name):
		var btn := _get_nearest_button()
		if btn:
			btn.try_interact()

func _get_nearest_button() -> InteractableButton:
	var nearest: InteractableButton = null
	var best_d := INF
	for area in get_overlapping_areas():
		if area is InteractableButton:
			var d := (area.global_position - global_position).length()
			if d < best_d and d <= max_distance:
				best_d = d
				nearest = area
	return nearest
