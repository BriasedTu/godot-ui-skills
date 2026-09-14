extends Control
## Visibility primitive. Its host owns modal trapping and navigation.

signal settled(is_open: bool)

@export var content: Control
var requested_open: bool = false
var duration_multiplier: float = 1.0
var _reduced_motion: bool = false
var _generation: int = 0
var _tween: Tween
var _input_snapshot: Array[Dictionary] = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(_update_pivot)
	_update_pivot()
	modulate.a = 0.0
	scale = Vector2.ONE * 0.97
	hide()
	_set_content_enabled(false)


func request_open(want_open: bool, instant: bool = false) -> void:
	requested_open = want_open
	_generation += 1
	var ticket := _generation
	if _tween != null:
		_tween.kill()
		_tween = null
	_set_content_enabled(want_open)
	if want_open:
		show()
	var target_alpha := 1.0 if want_open else 0.0
	var target_scale := Vector2.ONE if want_open or _reduced_motion else Vector2.ONE * 0.97
	if instant or _reduced_motion:
		modulate.a = target_alpha
		scale = target_scale
		_complete(ticket, want_open)
		return
	var seconds := (0.20 if want_open else 0.14) * maxf(0.01, duration_multiplier)
	_tween = create_tween().set_parallel(true)
	_tween.set_ignore_time_scale(true)
	_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "modulate:a", target_alpha, seconds)
	_tween.tween_property(self, "scale", target_scale, seconds)
	_tween.chain().tween_callback(_complete.bind(ticket, want_open))


func set_reduced_motion(enabled: bool) -> void:
	if _reduced_motion == enabled:
		return
	_reduced_motion = enabled
	if is_inside_tree():
		request_open(requested_open, true)


func _complete(ticket: int, is_open: bool) -> void:
	if ticket != _generation or requested_open != is_open:
		return
	_tween = null
	visible = is_open
	settled.emit(is_open)


func _set_content_enabled(enabled: bool) -> void:
	if not is_instance_valid(content):
		return
	if enabled:
		for saved: Dictionary in _input_snapshot:
			var node: Node = saved["node"]
			if not is_instance_valid(node):
				continue
			node.process_mode = saved["process_mode"]
			if node is Control:
				node.focus_mode = saved["focus_mode"]
				node.mouse_filter = saved["mouse_filter"]
		_input_snapshot.clear()
		return
	if not _input_snapshot.is_empty():
		return
	var focused := get_viewport().gui_get_focus_owner()
	if focused != null and (focused == content or content.is_ancestor_of(focused)):
		focused.release_focus()
	_block_subtree(content)


func _block_subtree(node: Node) -> void:
	var saved := {"node": node, "process_mode": node.process_mode}
	if node is Control:
		saved["focus_mode"] = node.focus_mode
		saved["mouse_filter"] = node.mouse_filter
		node.focus_mode = Control.FOCUS_NONE
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_input_snapshot.append(saved)
	node.process_mode = Node.PROCESS_MODE_DISABLED
	for child: Node in node.get_children():
		_block_subtree(child)


func _update_pivot() -> void:
	pivot_offset = size * 0.5


func _exit_tree() -> void:
	_generation += 1
	if _tween != null:
		_tween.kill()
		_tween = null
