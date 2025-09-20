# scripts/TimeHUD.gd — Big timer label with color states and float popups
extends Label

@export var warn_threshold: float = 60.0
@export var danger_threshold: float = 30.0

var _popups: Array[Label] = []

func _ready() -> void:
	text = Game.format_mm_ss(Game.time_left)
	add_theme_font_size_override("font_size", 48)
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_TOP

	Game.time_changed.connect(_on_time_changed)
	Game.time_ran_out.connect(_on_time_ran_out)

func _process(delta: float) -> void:
	# Simple float-up fade for +/- seconds popups
	for lbl in _popups:
		lbl.position.y -= 30.0 * delta
		lbl.modulate.a -= 1.5 * delta
		if lbl.modulate.a <= 0.0:
			lbl.queue_free()
	_popups = _popups.filter(func(n): return is_instance_valid(n))

func _on_time_changed(new_time: float, delta_seconds: float) -> void:
	text = Game.format_mm_ss(new_time)
	if new_time <= danger_threshold:
		add_theme_color_override("font_color", Color(1, 0, 0))
	elif new_time <= warn_threshold:
		add_theme_color_override("font_color", Color(1, 0.75, 0))
	else:
		add_theme_color_override("font_color", Color(0.2, 1, 0.2))

	if abs(delta_seconds) > 0.01:
		_spawn_popup(delta_seconds)

func _spawn_popup(delta_seconds: float) -> void:
	var lbl := Label.new()
	lbl.text = ("%+dс" % int(round(delta_seconds)))
	lbl.position = Vector2(size.x / 2.0, 64.0)
	add_child(lbl)
	_popups.append(lbl)

func _on_time_ran_out() -> void:
	# Minimal fail overlay + restart hint
	get_tree().paused = true

	var overlay := ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.7)
	overlay.size = get_viewport_rect().size
	add_child(overlay)

	var msg := Label.new()
	msg.text = "TIME OVER\nPress R to Restart"
	msg.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	msg.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	msg.add_theme_font_size_override("font_size", 48)
	msg.size = overlay.size
	overlay.add_child(msg)

	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and (event.keycode == KEY_R or event.keycode == KEY_ENTER):
		get_tree().paused = false
		Game.reset_time()
		get_tree().reload_current_scene()
