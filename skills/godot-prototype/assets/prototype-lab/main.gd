extends Control
## An isolated native comparison host; no player data or global clock changes.

const NAMES: Array[String] = ["Quiet", "Directional", "Playful"]
const AXES: Array[String] = ["Opacity only / least distraction", "Short travel / spatial emphasis", "Small overshoot / expressive arrival"]
var persist_selection: bool = true
var current: int = 0
var stage: Control
var accepted_actions: int = 0
var _caption: Label
var _result: Label
var _picker: Array[Button] = []
var _tween: Tween
var _reduced: bool = false
var _slow: bool = false
var _generation: int = 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var margin := MarginContainer.new()
	add_child(margin)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for edge: String in ["left", "top", "right", "bottom"]:
		margin.add_theme_constant_override("margin_" + edge, 32)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 16)
	margin.add_child(column)
	var heading := Label.new()
	heading.text = "NATIVE PROTOTYPES / Compare the motion"
	heading.add_theme_font_size_override("font_size", 26)
	column.add_child(heading)
	_caption = Label.new()
	column.add_child(_caption)
	stage = Control.new()
	stage.custom_minimum_size = Vector2(0, 290)
	stage.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(stage)
	_result = Label.new()
	_result.text = "Try the action, then replay or switch."
	column.add_child(_result)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	column.add_child(row)
	for index: int in range(NAMES.size()):
		var button := Button.new()
		button.text = "%d  %s" % [index + 1, NAMES[index]]
		button.toggle_mode = true
		button.pressed.connect(select_variant.bind(index))
		row.add_child(button)
		_picker.append(button)
	var replay_button := Button.new()
	replay_button.text = "Replay / R"
	replay_button.pressed.connect(replay)
	row.add_child(replay_button)
	var preferences := HBoxContainer.new()
	column.add_child(preferences)
	var reduced := CheckButton.new()
	reduced.text = "Reduced motion"
	reduced.toggled.connect(set_reduced_motion)
	preferences.add_child(reduced)
	var slow := CheckButton.new()
	slow.text = "Slow playback (local)"
	slow.toggled.connect(set_slow_playback)
	preferences.add_child(slow)
	if persist_selection:
		var config := ConfigFile.new()
		if config.load("user://prototype_picker.cfg") == OK:
			current = clampi(int(config.get_value("picker", "variant", 0)), 0, NAMES.size() - 1)
	select_variant(current)
	_picker[current].grab_focus()


func select_variant(index: int) -> void:
	current = clampi(index, 0, NAMES.size() - 1)
	_caption.text = NAMES[current] + " — " + AXES[current]
	for position_index: int in range(_picker.size()):
		_picker[position_index].set_pressed_no_signal(position_index == current)
	if persist_selection:
		var config := ConfigFile.new()
		config.set_value("picker", "variant", current)
		config.save("user://prototype_picker.cfg")
	replay()


func replay() -> void:
	_generation += 1
	var ticket := _generation
	if _tween != null:
		_tween.kill()
		_tween = null
	var focused := get_viewport().gui_get_focus_owner()
	var restore_picker := focused != null and stage.is_ancestor_of(focused)
	for old: Node in stage.get_children():
		stage.remove_child(old)
		old.queue_free()
	accepted_actions = 0
	_result.text = "Accepted actions: 0"
	var panel := PanelContainer.new()
	stage.add_child(panel)
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.offset_left = 90
	panel.offset_right = -90
	panel.offset_top = 24
	panel.offset_bottom = -24
	var surface := StyleBoxFlat.new()
	surface.bg_color = Color("1e2c41")
	surface.set_corner_radius_all(16)
	surface.content_margin_left = 28
	surface.content_margin_right = 28
	surface.content_margin_top = 24
	surface.content_margin_bottom = 24
	panel.add_theme_stylebox_override("panel", surface)
	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 16)
	panel.add_child(body)
	var title := Label.new()
	title.text = "A place to prepare"
	title.add_theme_font_size_override("font_size", 24)
	body.add_child(title)
	var description := Label.new()
	description.text = "Choose supplies before your next journey.\nThe content stays the same so the motion is easy to compare."
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(description)
	var action := Button.new()
	action.name = "SampleAction"
	action.text = "Prepare supplies"
	action.pressed.connect(func() -> void:
		if ticket == _generation:
			accepted_actions += 1
			_result.text = "Accepted actions: %d" % accepted_actions
	)
	body.add_child(action)
	panel.resized.connect(func() -> void: panel.pivot_offset = panel.size * 0.5)
	panel.pivot_offset = panel.size * 0.5
	if restore_picker:
		_picker[current].grab_focus()
	if _reduced:
		return
	panel.modulate.a = 0.0
	_tween = create_tween().set_parallel(true).set_ignore_time_scale(true)
	var seconds := (0.18 if current == 0 else 0.24) * (3.0 if _slow else 1.0)
	_tween.tween_property(panel, "modulate:a", 1.0, seconds).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if current == 1:
		panel.offset_top += 16
		panel.offset_bottom += 16
		_tween.tween_property(panel, "offset_top", 24.0, seconds).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		_tween.tween_property(panel, "offset_bottom", -24.0, seconds).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	elif current == 2:
		panel.scale = Vector2.ONE * 0.96
		_tween.tween_property(panel, "scale", Vector2.ONE, seconds).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func set_reduced_motion(enabled: bool) -> void:
	_reduced = enabled
	replay()


func set_slow_playback(enabled: bool) -> void:
	_slow = enabled
	replay()


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var key := event as InputEventKey
	if not key.pressed or key.echo or key.ctrl_pressed or key.alt_pressed or key.meta_pressed or key.shift_pressed:
		return
	var focused := get_viewport().gui_get_focus_owner()
	if focused is LineEdit or focused is TextEdit:
		return
	if key.keycode >= KEY_1 and key.keycode < KEY_1 + NAMES.size():
		select_variant(key.keycode - KEY_1)
	elif key.keycode == KEY_R:
		replay()
	else:
		return
	get_viewport().set_input_as_handled()


func _exit_tree() -> void:
	_generation += 1
	if _tween != null:
		_tween.kill()
