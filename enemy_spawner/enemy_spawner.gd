extends Node2D

@export var enemy_prefab : PackedScene
@export var target : Node2D
@onready var timer: Timer = $Timer

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

func _on_timer_timeout() -> void:
	
	var enemy = enemy_prefab.instantiate()
	enemy.Player = target
	add_child(enemy)
	
