# scripts/ExitArea.gd — завершение уровня и экран результатов
extends Area2D
class_name ExitArea

var _finished := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if _finished:
		return
	if body is CharacterBody2D:
		_finished = true
		_show_results()

func _show_results() -> void:
	get_tree().paused = true

	var left := Game.time_left
	var time_str := Game.format_mm_ss(left)
	var score := int(round(left * 5.0))  # простая формула очков

	var overlay := ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.75)
	overlay.size = get_viewport_rect().size
	add_child(overlay)

	var msg := Label.new()
	msg.size = overlay.size
	msg.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	msg.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	msg.add_theme_font_size_override("font_size", 42)
	msg.text = "LEVEL COMPLETE\nОсталось времени: %s\nОчки: %d\n\n[Enter] — перезапуск уровня\n[R] — тоже перезапуск" % [time_str, score]
	overlay.add_child(msg)

	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and (event.keycode == KEY_ENTER or event.keycode == KEY_R):
		get_tree().paused = false
		Game.reset_time()
		get_tree().reload_current_scene()
