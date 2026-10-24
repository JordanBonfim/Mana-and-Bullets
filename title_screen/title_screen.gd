extends CanvasLayer


# Menus
@onready var main_menu: VBoxContainer = %MainMenu
@onready var settings_menu: VBoxContainer = %SettingsMenu

# Buttons
@onready var play_button: Button = %PlayButton
@onready var settings_button: Button = %SettingsButton
@onready var back_to_main_menu_button: Button = %BackToMainMenuButton
@onready var apply_settings_button: Button = %ApplySettingsButton


@onready var resolution_options: OptionButton = %ResolutionOptions
@onready var window_mode_options: OptionButton = %WindowModeOptions


var current_window_mode = "windowed"

var resolutions: Array[Vector2i] = [
	Vector2i(1280, 720),
	Vector2i(1366, 768),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160)
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for resolution in resolutions:
		resolution_options.add_item(
			str(resolution.x) + "x" + str(resolution.y)
		)
	resolution_options.select(3)
		
	window_mode_options.add_item("Windowed")
	window_mode_options.add_item("Fullscreen")
	window_mode_options.add_item("Borderless Window")
	window_mode_options.add_item("Borderless Fullscreen")

	
	show_main_menu()
	play_button.pressed.connect(switch_to_play_scene)
	settings_button.pressed.connect(show_settings_menu)
	back_to_main_menu_button.pressed.connect(show_main_menu)
	
	window_mode_options.item_selected.connect(change_window_mode)
	resolution_options.item_selected.connect(change_window_resolution)
		
func change_window_mode(index:int) -> void:
	match window_mode_options.selected:
		0: # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			resolution_options.disabled = false
		1: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			resolution_options.disabled = true
			
		2: # Borderless window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			resolution_options.disabled = false
		
		2: # Borderless fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			resolution_options.disabled = true
			
			
func change_window_resolution(index:int) -> void:
	var selected_index = resolution_options.selected
	var resolution = resolutions[selected_index]
	print("changing resolution to:", resolution)
	DisplayServer.window_set_size(resolution)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func switch_to_play_scene() -> void:
	get_tree().change_scene_to_file("res://levels/level1.tscn")
	pass
	
func show_settings_menu() -> void:
	main_menu.visible = false
	settings_menu.visible = true
	back_to_main_menu_button.grab_focus()
	
func show_main_menu() -> void:
	main_menu.visible = true
	settings_menu.visible = false
	play_button.grab_focus()
	
	

	
	
		

	
	
	

	
	
