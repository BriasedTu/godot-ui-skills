extends SceneTree
## Run with a lab's --path and --script <repo>/tools/capture_lab.gd.
## Requires a real renderer; output directory is supplied after --.

var _output: String


func _initialize() -> void:
	var arguments := OS.get_cmdline_user_args()
	if arguments.is_empty():
		push_error("Supply an output directory after --")
		quit(1)
		return
	_output = arguments[0]
	DirAccess.make_dir_recursive_absolute(_output)
	_capture_lab.call_deferred()


func _capture_lab() -> void:
	var packed: PackedScene = load("res://main.tscn")
	var lab := packed.instantiate()
	if lab.get("persist_selection") != null:
		lab.set("persist_selection", false)
	root.add_child(lab)
	await create_timer(0.4).timeout
	if lab.has_method("select_variant"):
		for index: int in range(3):
			lab.call("select_variant", index)
			await create_timer(0.07).timeout
			await _save("variant-%d-moving.png" % (index + 1))
			await create_timer(0.3).timeout
			await _save("variant-%d-settled.png" % (index + 1))
	else:
		await _save("motion-initial.png")
		var panel := lab.get("_panel") as Control
		panel.call("request_open", true)
		await create_timer(0.07).timeout
		await _save("motion-opening.png")
		await create_timer(0.3).timeout
		await _save("motion-open.png")
		root.size = Vector2i(760, 640)
		await create_timer(0.25).timeout
		await _save("motion-narrow.png")
	print("Rendered capture complete")
	lab.queue_free()
	await process_frame
	quit(0)


func _save(filename: String) -> void:
	await RenderingServer.frame_post_draw
	var frame := root.get_texture().get_image()
	if frame == null or frame.is_empty():
		push_error("No rendered viewport image; do not use a dummy renderer")
		quit(1)
		return
	var result := frame.save_png(_output.path_join(filename))
	if result != OK:
		push_error("Could not save rendered image: %s" % error_string(result))
		quit(1)
