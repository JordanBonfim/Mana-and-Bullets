extends Node2D

@export var enemy_prefab : PackedScene
@export var target : Node2D
@onready var timer: Timer = $Timer
const CYAN_SLIME = preload("uid://bskrtlj4ec1fy")
"res://Enemy/cyan_slime/cyan_slime.tscn"
@export var cyan_slime: PackedScene
@export var ultra_mage: PackedScene

#region DIFICULTY CONFIG

@export var wave_number : int = 1


#endregion 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		
		if event.keycode == KEY_2:
			print("timout:", timer.wait_time)
			timer.wait_time-=0.2
		elif event.keycode == KEY_3:
			print("timout:", timer.wait_time)
			timer.wait_time+=0.2
		
		elif event.keycode == KEY_5:
			print("timer paused:", timer.paused)
			timer.paused = true	
		elif event.keycode == KEY_6:
			print("timer paused:", timer.paused)
			timer.paused = false	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func spawn_slime() -> void:
	var enemy = cyan_slime.instantiate()


func _on_timer_timeout() -> void:
	
	var enemy = cyan_slime.instantiate()
	enemy.Player = target
	add_child(enemy)
	
