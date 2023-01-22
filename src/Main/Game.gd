extends Node

onready var coins = 11

func _init():
	OS.min_window_size = OS.window_size
	OS.max_window_size = OS.get_screen_size()


func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		# We need to clean up a little bit first to avoid Viewport errors.
		if name == "Splitscreen":
			$Black/SplitContainer/ViewportContainer1.free()
			$Black.queue_free()


func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
		get_tree().set_input_as_handled()
	
	elif event.is_action_pressed("toggle_pause"):
		print("toggle pause")
		var tree = get_tree()
		tree.paused = not tree.paused
		var pause_menu = $Level/InterfaceLayer/PauseMenu
		if tree.paused:
			print("open pause menu")
			pause_menu.open()
		else:
			print("close pause menu")
			pause_menu.close()
		get_tree().set_input_as_handled()
