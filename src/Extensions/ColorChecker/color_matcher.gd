extends PanelContainer


var api: Node
var left_color_old: Color
var right_color_old: Color

var color_picker_panel
# This script acts as a setup for the extension

var main_viewport: SubViewportContainer

func _enter_tree() -> void:
	## NOTE: use get_node_or_null("/root/ExtensionsApi") to access api.
	api = get_node_or_null("/root/ExtensionsApi")
	api.signals.signal_tool_color_changed(update_color)
	color_picker_panel = api.general.get_global().control.get_node(
		"MenuAndUI/UI/DockableContainer/Color Picker"
	)
	main_viewport = api.general.get_global().main_viewport
	if main_viewport:
		main_viewport.mouse_entered.connect(show_isolation.bind(false))
		main_viewport.mouse_exited.connect(show_isolation.bind(true))
	left_color_old = color_picker_panel.left_color_rect.color
	right_color_old = color_picker_panel.right_color_rect.color
	visible = false


func show_isolation(show_border):
	var tween = create_tween()
	if show_border:
		tween.tween_property(self, "self_modulate", Color.WHITE, 0.2)
	else:
		tween.tween_property(self, "self_modulate", Color.TRANSPARENT, 0.2)


func _exit_tree() -> void:
	if main_viewport:
		main_viewport.mouse_entered.disconnect(show_isolation)
		main_viewport.mouse_exited.disconnect(show_isolation)


func _input(event: InputEvent) -> void:
	var active_tool = api.tools.autoload().active_button
	# Check if color has been placed (update it if it is)
	if active_tool == MOUSE_BUTTON_LEFT:
		left_color_old = color_picker_panel.left_color_rect.color
		visible = false
	elif active_tool == MOUSE_BUTTON_RIGHT:
		right_color_old = color_picker_panel.right_color_rect.color
		visible = false

	if event is InputEventMouseMotion:
		position = event.position
		position.y -= size.y + 10
		position.x -= size.x / 2


	if Input.is_action_just_pressed("ui_cancel"):
		visible = false


func update_color(color_info: Dictionary, button: int):
	var tool_slot: int = api.tools.autoload().picking_color_for
	# show left old color if we are picking for left color and vice versa
	if tool_slot == MOUSE_BUTTON_LEFT:
		%old.color = left_color_old
	elif tool_slot == MOUSE_BUTTON_RIGHT:
		%old.color = right_color_old

	# this check fixes a bug when we swap colors
	if tool_slot == button:
		%new.color = color_info.get("color", Color.WHITE)
	visible = true
