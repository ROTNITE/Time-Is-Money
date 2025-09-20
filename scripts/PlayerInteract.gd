# scripts/PlayerInteract.gd — простой радиус интеракции
extends Area2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		for body in get_overlapping_areas():
			if body is InteractableButton:
				body.try_interact()
				return
