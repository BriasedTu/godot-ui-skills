extends SceneTree
## Behavioral checks for the native motion examples; no player files are used.
## Run: godot --headless --path <motion-lab> --script res://verify.gd
## This checks state and native input, not visual quality or physical devices.

var _panel_script: Script
var _button_script: Script
var _checks: int = 0
var _failures: int = 0
var _finished: bool = false


func _initialize() -> void:
	create_timer(15.0, true, false, true).timeout.connect(_watchdog)
	_run.call_deferred()


func _run() -> void:
	await process_frame
	for resource_path: String in ["res://motion_panel.gd", "res://motion_button.gd"]:
		if not ResourceLoader.exists(resource_path):
			_check(false, "Required example resource cannot be loaded: " + resource_path)
	if _failures > 0:
		_finish()
		return
	_panel_script = load("res://motion_panel.gd") as Script
	_button_script = load("res://motion_button.gd") as Script
	if _panel_script == null or _button_script == null:
		_check(false, "Both example scripts must load successfully")
		_finish()
		return
	await _test_initial_and_instant_state()
	await _test_paused_and_zero_time_scale()
	await _test_close_blocks_native_input()
	await _test_latest_request_wins()
	await _test_disposal_during_motion()
	await _test_reduced_motion_during_transition()
	await _test_container_focus_and_activation()
	_finish()


func _new_panel() -> Control:
	var panel := _panel_script.new() as Control
	var content := Control.new()
	content.name = "Content"
	content.size = Vector2(320.0, 180.0)
	panel.add_child(content)
	panel.set("content", content)
	root.add_child(panel)
	return panel


func _test_initial_and_instant_state() -> void:
	var panel := _new_panel()
	var content := panel.get("content") as Control
	_check(not panel.visible and is_zero_approx(panel.modulate.a), "Panel starts hidden and transparent")
	_check(not bool(panel.get("requested_open")), "Initial requested state is closed")
	panel.call("request_open", true, true)
	_check_open(panel, "Instant open")
	panel.call("request_open", false, true)
	_check(not panel.visible and is_zero_approx(panel.modulate.a), "Instant close settles visibility and opacity")
	_check(content.process_mode == Node.PROCESS_MODE_DISABLED, "Closed content cannot process input")
	panel.queue_free()
	await process_frame


func _test_paused_and_zero_time_scale() -> void:
	var panel := _new_panel()
	var settlements: Array[bool] = []
	panel.connect("settled", func(is_open: bool) -> void: settlements.append(is_open))
	paused = true
	Engine.time_scale = 0.0
	panel.call("request_open", true)
	await _real_delay(0.40)
	_check_open(panel, "Open while paused at zero time scale")
	_check(settlements == [true], "Paused opening reports one settled event")
	panel.call("request_open", false)
	var content := panel.get("content") as Control
	_check(content.process_mode == Node.PROCESS_MODE_DISABLED, "Close disables content immediately before fading")
	await _real_delay(0.30)
	_check(not panel.visible and is_zero_approx(panel.modulate.a), "Close settles while paused at zero time scale")
	_check(settlements == [true, false], "Paused closing reports its own settled event")
	_check(paused and is_zero_approx(Engine.time_scale), "Presentation does not change gameplay pause or time scale")
	paused = false
	Engine.time_scale = 1.0
	panel.queue_free()
	await process_frame


func _test_close_blocks_native_input() -> void:
	var panel := _panel_script.new() as Control
	var content := Control.new()
	panel.add_child(content)
	panel.set("content", content)
	var button := Button.new()
	button.text = "Outgoing action"
	button.process_mode = Node.PROCESS_MODE_ALWAYS
	button.focus_mode = Control.FOCUS_ALL
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	content.add_child(button)
	var activations: Array[bool] = []
	button.pressed.connect(func() -> void: activations.append(true))
	root.add_child(panel)
	panel.call("request_open", true, true)
	button.grab_focus()
	panel.call("request_open", false)
	_check(root.gui_get_focus_owner() != button, "Close releases outgoing focus")
	_send_action(&"ui_focus_next", true)
	_send_action(&"ui_focus_next", false)
	_check(root.gui_get_focus_owner() != button, "Native Tab cannot refocus fading content")
	_send_action(&"ui_accept", true)
	_send_action(&"ui_accept", false)
	_check(activations.is_empty(), "An ALWAYS descendant cannot activate while closing")
	_check(not button.can_process(), "Close also gates independently processing descendants")
	_check(button.mouse_filter == Control.MOUSE_FILTER_IGNORE, "Outgoing descendants cannot intercept pointer input")
	panel.call("request_open", true, true)
	_check(button.process_mode == Node.PROCESS_MODE_ALWAYS, "Reopen restores original descendant processing policy")
	_check(button.focus_mode == Control.FOCUS_ALL and button.mouse_filter == Control.MOUSE_FILTER_STOP, "Reopen restores native focus and pointer configuration")
	button.grab_focus()
	_send_action(&"ui_accept", true)
	_send_action(&"ui_accept", false)
	_check(activations.size() == 1, "Reopened native action activates exactly once")
	panel.queue_free()
	await process_frame


func _test_latest_request_wins() -> void:
	var panel := _new_panel()
	var settlements: Array[bool] = []
	panel.connect("settled", func(is_open: bool) -> void: settlements.append(is_open))
	panel.call("request_open", true)
	await _real_delay(0.04)
	var opening_alpha: float = panel.modulate.a
	panel.call("request_open", false)
	_check(is_equal_approx(panel.modulate.a, opening_alpha), "Reversing to close retains current opacity")
	await _real_delay(0.04)
	var closing_alpha: float = panel.modulate.a
	panel.call("request_open", true)
	_check(is_equal_approx(panel.modulate.a, closing_alpha), "Reopening retains current opacity")
	_check(bool(panel.get("requested_open")), "Newest open request is authoritative immediately")
	await _real_delay(0.45)
	_check_open(panel, "Rapid open-close-open")
	_check(settlements == [true], "Interrupted requests do not emit obsolete settled events")
	await _real_delay(0.20)
	_check_open(panel, "Old close completion cannot hide reopened panel")
	_check(settlements == [true], "No delayed duplicate completion occurs")
	panel.queue_free()
	await process_frame


func _test_disposal_during_motion() -> void:
	var panel := _new_panel()
	var settlements: Array[bool] = []
	panel.connect("settled", func(is_open: bool) -> void: settlements.append(is_open))
	panel.call("request_open", true)
	await _real_delay(0.03)
	panel.queue_free()
	await process_frame
	await _real_delay(0.35)
	_check(not is_instance_valid(panel), "Panel can be disposed while animating")
	_check(settlements.is_empty(), "Disposed panel produces no completion callback")
	_check(get_processed_tweens().is_empty(), "Disposed panel leaves no running tween")


func _test_reduced_motion_during_transition() -> void:
	var panel := _new_panel()
	var settlements: Array[bool] = []
	panel.connect("settled", func(is_open: bool) -> void: settlements.append(is_open))
	panel.call("request_open", true)
	await _real_delay(0.04)
	panel.call("set_reduced_motion", true)
	_check_open(panel, "Enabling reduced motion settles the requested open state immediately")
	await _real_delay(0.30)
	_check(settlements == [true], "Reduced motion replacement suppresses old completion")
	panel.call("request_open", false)
	await _real_delay(0.22)
	_check(not panel.visible and is_zero_approx(panel.modulate.a), "Future reduced-motion close settles promptly")
	panel.call("request_open", true)
	await _real_delay(0.22)
	_check_open(panel, "Future reduced-motion open")
	_check(settlements == [true, false, true], "Reduced-motion requests each settle once")
	panel.call("set_reduced_motion", false)
	panel.call("request_open", false)
	await _real_delay(0.03)
	panel.call("set_reduced_motion", true)
	_check(not panel.visible and is_zero_approx(panel.modulate.a), "Changing preference during close settles closed immediately")
	panel.queue_free()
	await process_frame


func _test_container_focus_and_activation() -> void:
	var grid := GridContainer.new()
	grid.columns = 3
	grid.position = Vector2(20.0, 20.0)
	grid.size = Vector2(420.0, 100.0)
	root.add_child(grid)
	var buttons: Array[Button] = []
	for index: int in range(3):
		var button := _button_script.new() as Button
		button.name = "Item%d" % index
		button.text = "Item %d" % index
		button.custom_minimum_size = Vector2(120.0, 60.0)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.focus_mode = Control.FOCUS_ALL
		grid.add_child(button)
		buttons.append(button)
	await process_frame
	await process_frame
	for index: int in range(2):
		buttons[index].focus_neighbor_right = buttons[index].get_path_to(buttons[index + 1])
	buttons[0].grab_focus()
	_check(root.gui_get_focus_owner() == buttons[0], "Native Button gains focus immediately")
	_send_action(&"ui_right", true)
	_send_action(&"ui_right", false)
	_check(root.gui_get_focus_owner() == buttons[1], "Native navigation moves focus during animation")
	_send_action(&"ui_right", true)
	_send_action(&"ui_right", false)
	_check(root.gui_get_focus_owner() == buttons[2], "Repeated navigation immediately selects the newest item")
	var chosen := buttons[2]
	var visual := chosen.get_node_or_null("Visual") as Control
	_check(visual != null, "Button provides a separate Visual child")
	if visual == null:
		grid.queue_free()
		await process_frame
		return
	_check(visual.mouse_filter == Control.MOUSE_FILTER_IGNORE, "Decorative Visual does not intercept native Button input")
	var activations: Array[bool] = []
	chosen.pressed.connect(func() -> void: activations.append(true))
	var original_rect := chosen.get_rect()
	_send_action(&"ui_accept", true)
	_check(chosen.is_pressed(), "Native Button pressed state starts before animation settles")
	_check(chosen.scale.is_equal_approx(Vector2.ONE), "Press animation keeps hit-target scale stable")
	_send_action(&"ui_accept", false)
	_check(activations.size() == 1, "One native press and release activates exactly once")
	_check(chosen.get_rect() == original_rect, "Selection and press preserve container layout geometry")
	grid.size.x += 180.0
	grid.queue_sort()
	await process_frame
	await process_frame
	var resized_rect := chosen.get_rect()
	_check(resized_rect.size.x > original_rect.size.x, "Container resize actually exercises changed item geometry")
	await _real_delay(0.30)
	_check(chosen.get_rect() == resized_rect, "Completing motion does not overwrite resized geometry")
	_check(chosen.scale.is_equal_approx(Vector2.ONE), "Container-owned Button remains unscaled after resize")
	_check(root.gui_get_focus_owner() == chosen, "Newest selection retains native focus after resize")
	chosen.call("set_reduced_motion", true)
	_check(visual.scale.is_equal_approx(Vector2.ONE), "Reduced motion removes decorative Button scaling immediately")
	_send_action(&"ui_accept", true)
	_send_action(&"ui_accept", false)
	_check(activations.size() == 2, "Reduced motion preserves native activation")
	grid.queue_free()
	await process_frame
	await _real_delay(0.25)
	_check(get_processed_tweens().is_empty(), "Disposed buttons leave no running tween")


func _send_action(action_name: StringName, is_down: bool) -> void:
	var event := InputEventAction.new()
	event.action = action_name
	event.pressed = is_down
	event.strength = 1.0 if is_down else 0.0
	root.push_input(event)


func _check_open(panel: Control, label: String) -> void:
	var content := panel.get("content") as Control
	_check(panel.visible and is_equal_approx(panel.modulate.a, 1.0), label + ": visible and opaque")
	_check(panel.scale.is_equal_approx(Vector2.ONE), label + ": wrapper at rest scale")
	_check(bool(panel.get("requested_open")), label + ": requested state remains open")
	_check(content.process_mode != Node.PROCESS_MODE_DISABLED, label + ": content remains enabled")


func _real_delay(seconds: float) -> void:
	await create_timer(seconds, true, false, true).timeout


func _check(condition: bool, message: String) -> void:
	_checks += 1
	if not condition:
		_failures += 1
		push_error("FAIL: " + message)


func _watchdog() -> void:
	if not _finished:
		push_error("FAIL: motion verification exceeded its 15-second real-time watchdog")
		paused = false
		Engine.time_scale = 1.0
		quit(2)


func _finish() -> void:
	_finished = true
	paused = false
	Engine.time_scale = 1.0
	print("Motion verification: %d checks, %d failures" % [_checks, _failures])
	quit(0 if _failures == 0 else 1)
