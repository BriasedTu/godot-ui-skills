extends Control

const MotionPanel = preload("res://motion_panel.gd")
const MotionButton = preload("res://motion_button.gd")
var _panel: Control
var _counter: Label
var _count: int = 0
var _cards: Array[Button] = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var margin := MarginContainer.new()
	add_child(margin)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for edge: String in ["left", "top", "right", "bottom"]:
		margin.add_theme_constant_override("margin_" + edge, 32)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 18)
	margin.add_child(column)
	var heading := Label.new()
	heading.text = "NATIVE MOTION / Interaction lab"
	heading.add_theme_font_size_override("font_size", 26)
	column.add_child(heading)
	var hint := Label.new()
	hint.text = "Navigate the cards. Reverse the panel mid-flight. Input stays immediate."
	column.add_child(hint)
	var grid := GridContainer.new()
	grid.columns = 3
	column.add_child(grid)
	for title: String in ["Compass", "Lantern", "Journal"]:
		var card := MotionButton.new()
		card.text = title
		card.custom_minimum_size = Vector2(180, 92)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.pressed.connect(_activated)
		grid.add_child(card)
		_cards.append(card)
	_counter = Label.new()
	_counter.text = "Accepted actions: 0"
	column.add_child(_counter)
	var options := HBoxContainer.new()
	options.add_theme_constant_override("separation", 16)
	column.add_child(options)
	var toggle := Button.new()
	toggle.text = "Toggle panel"
	toggle.pressed.connect(func() -> void: _panel.request_open(not _panel.requested_open))
	options.add_child(toggle)
	var reduce := CheckButton.new()
	reduce.text = "Reduced motion"
	reduce.toggled.connect(func(value: bool) -> void:
		_panel.set_reduced_motion(value)
		for card: Button in _cards:
			card.set_reduced_motion(value)
	)
	options.add_child(reduce)
	var pause := CheckButton.new()
	pause.text = "Pause game clock"
	pause.toggled.connect(func(value: bool) -> void: get_tree().paused = value)
	options.add_child(pause)
	var slow := CheckButton.new()
	slow.text = "Slow panel"
	slow.toggled.connect(func(value: bool) -> void: _panel.duration_multiplier = 3.0 if value else 1.0)
	column.add_child(slow)
	var slot := Control.new()
	slot.custom_minimum_size = Vector2(0, 170)
	slot.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(slot)
	_panel = MotionPanel.new()
	var content := PanelContainer.new()
	_panel.content = content
	_panel.add_child(content)
	var inside := VBoxContainer.new()
	content.add_child(inside)
	var message := Label.new()
	message.text = "A reversible panel\n\nOld exits cannot hide a newer opening.\nThis helper handles visibility; a modal host would own focus trapping."
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.size_flags_vertical = Control.SIZE_EXPAND_FILL
	inside.add_child(message)
	var action := Button.new()
	action.text = "Panel action"
	action.pressed.connect(_activated)
	inside.add_child(action)
	# Build the content before the gate takes its initial input snapshot in _ready.
	slot.add_child(_panel)
	_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_cards[0].grab_focus()


func _activated() -> void:
	_count += 1
	_counter.text = "Accepted actions: %d" % _count
