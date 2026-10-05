extends CanvasLayer


# Menus
@onready var main_menu: VBoxContainer = %MainMenu

# Buttons
@onready var play_button: Button = %PlayButton







# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_main_menu()
	
	play_button.pressed.connect( switch_to_play_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func switch_to_play_scene() -> void:
	get_tree().change_scene_to_file("res://levels/level1.tscn")
	pass

func show_main_menu() -> void:
	main_menu.visible= true
	play_button.grab_focus()
	
	
