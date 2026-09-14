extends Button
## Native hit/focus/activation; only the nested Visual changes scale.

var _visual: Panel
var _surface: StyleBoxFlat
var _tween: Tween
var _hovered: bool = false
var _down: bool = false
var _reduced_motion: bool = false


func _ready() -> void:
	flat = true
	for state: String in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color", "font_disabled_color"]:
		add_theme_color_override(state, Color.TRANSPARENT)
	_visual = Panel.new()
	_visual.name = "Visual"
	_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_visual)
	_visual.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_surface = StyleBoxFlat.new()
	_surface.set_corner_radius_all(10)
	_surface.border_color = Color("8bc8ff")
	_visual.add_theme_stylebox_override("panel", _surface)
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_visual.add_child(label)
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_visual.resized.connect(_update_pivot)
	mouse_entered.connect(func() -> void: _hovered = true; _refresh())
	mouse_exited.connect(func() -> void: _hovered = false; _refresh())
	focus_entered.connect(_refresh)
	focus_exited.connect(func() -> void: _down = false; _refresh())
	button_down.connect(func() -> void: _down = true; _refresh())
	button_up.connect(func() -> void: _down = false; _refresh())
	_update_pivot()
	_refresh(true)


func set_reduced_motion(enabled: bool) -> void:
	_reduced_motion = enabled
	if is_instance_valid(_visual):
		_refresh(true)


func set_available(available: bool) -> void:
	disabled = not available
	_down = false
	if is_instance_valid(_visual):
		_refresh(true)


func _refresh(instant: bool = false) -> void:
	if _tween != null:
		_tween.kill()
	var emphasized := has_focus() or _hovered
	_surface.bg_color = Color("293e58") if emphasized else Color("1e2c41")
	_surface.set_border_width_all(2 if has_focus() else 0)
	_visual.modulate.a = 0.45 if disabled else 1.0
	var factor := 1.0
	if not _reduced_motion and not disabled:
		factor = 0.97 if _down else (1.02 if emphasized else 1.0)
	if instant:
		_visual.scale = Vector2.ONE * factor
		_tween = null
		return
	_tween = create_tween().set_ignore_time_scale(true)
	_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(_visual, "scale", Vector2.ONE * factor, 0.08 if _down else 0.12)


func _update_pivot() -> void:
	_visual.pivot_offset = _visual.size * 0.5


func _exit_tree() -> void:
	if _tween != null:
		_tween.kill()
