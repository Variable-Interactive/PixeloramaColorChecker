extends Node

var api: Node

var color_picker_panel
var color_preview: Control
# This script acts as a setup for the extension
func _enter_tree() -> void:
	## NOTE: use get_node_or_null("/root/ExtensionsApi") to access api.
	api = get_node_or_null("/root/ExtensionsApi")
	#color_picker_panel = api.general.get_global().control.get_node(
		#"MenuAndUI/UI/DockableContainer/Color Picker"
	#)

func _ready() -> void:
	color_preview = preload("res://src/Extensions/ColorChecker/color_matcher.tscn").instantiate()
	#color_picker_panel.find_child("VerticalContainer").add_child(color_preview)
	add_child(color_preview)
	color_preview.get_parent().move_child(color_preview, 1)


func _exit_tree() -> void:  # Extension is being uninstalled or disabled
	color_preview.queue_free()
