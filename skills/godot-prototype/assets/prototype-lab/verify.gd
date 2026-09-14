extends SceneTree

var _failures: int = 0
var _checks: int = 0


func _initialize() -> void:
	_run.call_deferred()


func _run() -> void:
	if not ResourceLoader.exists("res://main.tscn"):
		push_error("Missing native prototype scene")
		quit(1)
		return
	var scene: PackedScene = load("res://main.tscn")
	var lab := scene.instantiate()
	lab.set("persist_selection", false)
	root.add_child(lab)
	await process_frame
	for index: int in range(3):
		lab.call("select_variant", index)
		var selected := lab.get("current") as int
		_check(selected == index, "Variant selection is immediate")
		var stage := lab.get("stage") as Control
		_check(stage.get_child_count() == 1, "Only one variant is mounted")
		var old := stage.get_child(0)
		lab.call("replay")
		_check(old.get_parent() == null, "Replay removes old input ownership immediately")
		await process_frame
		_check(not is_instance_valid(old), "Replayed instance is freed")
		lab.call("set_reduced_motion", true)
		var panel := stage.get_child(0) as Control
		_check(panel.scale.is_equal_approx(Vector2.ONE) and is_equal_approx(panel.modulate.a, 1.0), "Reduced motion settles the new variant")
		var button := panel.find_child("SampleAction", true, false) as Button
		_check(button != null, "Each variant includes a working native action")
		button.pressed.emit()
		_check(int(lab.get("accepted_actions")) == 1, "Selected variant accepts an action once")
		lab.call("set_reduced_motion", false)
	var game_scale := Engine.time_scale
	lab.call("set_slow_playback", true)
	_check(is_equal_approx(Engine.time_scale, game_scale), "Slow preview does not change game time scale")
	lab.call("select_variant", 999)
	_check(int(lab.get("current")) == 2, "Out-of-range selection is clamped")
	lab.queue_free()
	await process_frame
	await create_timer(0.35).timeout
	_check(get_processed_tweens().is_empty(), "Closing the lab cancels owned tweens")
	print("Prototype verification: %d checks, %d failures" % [_checks, _failures])
	quit(1 if _failures else 0)


func _check(condition: bool, label: String) -> void:
	_checks += 1
	if not condition:
		_failures += 1
		push_error(label)
