extends CanvasLayer

@onready var resume_button: Button = $Control/VBoxContainer/resume_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Messages.game_paused.connect(game_paused)
	Messages.game_unpaused.connect(game_unpaused)

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_paused() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	visible = true

func game_unpaused() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	visible = false


func _on_resume_button_pressed() -> void:
	Messages.game_unpaused.emit()
	pass # Replace with function body.
