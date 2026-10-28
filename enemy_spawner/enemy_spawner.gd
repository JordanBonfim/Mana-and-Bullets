extends Node2D

@export var enemy_prefab : PackedScene
@export var target : Node2D
@onready var timer: Timer = $Timer
const CYAN_SLIME = preload("uid://bskrtlj4ec1fy")
"res://Enemy/cyan_slime/cyan_slime.tscn"

# Enemies scenes
@export var cyan_slime: PackedScene
@export var ultra_mage: PackedScene

#region DIFICULTY CONFIG

@export var wave_number : int = 1
@export var max_wave_budget : int = 10
@export var current_wave_budget : int = max_wave_budget
@export var skip_wave : bool = false

var enemies: Array[String] = ["slime", "mage"]
var enemies_cost: Array[int] = [1, 2]

#endregion 

var random_num_generator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_2:
			#print("timout:", timer.wait_time)
			timer.wait_time-=0.2
		elif event.keycode == KEY_3:
			#print("timout:", timer.wait_time)
			timer.wait_time+=0.2
		
		elif event.keycode == KEY_5:
			#print("timer paused:", timer.paused)
			timer.paused = true	
		elif event.keycode == KEY_6:
			#print("timer paused:", timer.paused)
			timer.paused = false	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func spawn_enemy(enemy_index: int) -> void:
	var enemy = cyan_slime.instantiate()
	match enemy_index:
		0:
			enemy = cyan_slime.instantiate()
		1:
			enemy = ultra_mage.instantiate()
	enemy.Player = target
	enemy.wave_number = wave_number+1
	add_child(enemy)
	
	
func select_enemy_to_spawn(budget := 0) -> void:
	var enemy_index = random_num_generator.randi_range(0, enemies.size()-1)
	while budget < enemies_cost[enemy_index]:
		enemy_index = random_num_generator.randi_range(0, enemies.size()-1)
	current_wave_budget -= enemies_cost[enemy_index]
	spawn_enemy(enemy_index)

func _on_timer_timeout() -> void:
	if(current_wave_budget < 1):
		## Clear wave to go to the next one
		if(get_children().size()<2 or skip_wave):
			wave_number+=1
			max_wave_budget += 5
			current_wave_budget = max_wave_budget
			Messages.increase_wave.emit(1)
			timer.wait_time = timer.wait_time - (timer.wait_time / 10)
	else:
		select_enemy_to_spawn(current_wave_budget)
