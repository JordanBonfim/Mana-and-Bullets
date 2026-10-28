extends CharacterBody2D

const speed = 200

var Player: Node2D
var direction: Vector2 = Vector2.ZERO
var is_facing_left:bool = false


#region ENEMY STATS
# base stats, updataded inside on_ready function
var base_max_hp: float = 20
var base_damage_to_player: float = 20
var base_xp_drop: float = 15

var hp: float = base_max_hp
var max_hp: float = base_max_hp
var damage_to_player: float = base_damage_to_player
var xp_drop: float = base_xp_drop

var firing_cooldown: float = 1.4 # in seconds

@export var growth_factor: float = 1
@export var quadratic_multiplier: float = 0.22
@export var wave_number : int = 1
#endregion

var random = RandomNumberGenerator.new()
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurt_box: CollisionShape2D = $Area2D/Hurt_box

@export var player_in_range: bool = false
var ready_to_fire: bool = true

@onready var firing_timer: Timer = $firing_timer
@onready var marker_2d: Marker2D = $Marker2D


const MAGE_PROJECTILE = preload("uid://c3cb5sedl8gx5")

func _ready() -> void:
	$AnimationPlayer.play("walk")
	random.randomize()
	
	var half = get_viewport().get_visible_rect().size / 2
	
	var raio:int = sqrt(pow(half.x,2)+pow(half.y,2))
	var angulo:int = random.randi() % 360
	#print("Angulo:", angulo)
	
	global_position = Player.global_position + Vector2(
	cos(angulo),
	sin(angulo)
	) * raio
	
	max_hp = hp * pow(wave_number,2) * pow(growth_factor, wave_number - 1) * quadratic_multiplier
	hp = max_hp
	damage_to_player = damage_to_player * pow(wave_number,2) * pow(growth_factor, wave_number - 1) * quadratic_multiplier
	xp_drop = xp_drop * pow(wave_number,2) * pow(growth_factor, wave_number - 1) * (quadratic_multiplier - 0.1)
	
	
	#print("--- ULTRA MAGE SPAWNED ---")
	#print("Wave: ", wave_number)
	#print("HP: ", hp, "/", max_hp)
	#print("Damage: ", damage_to_player)
	#print("XP Drop: ", xp_drop)
	#print("---------------------")
	
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		
		if event.keycode == KEY_1:
			queue_free()
	
func _physics_process(delta: float) -> void:
	
	#if $AnimationPlayer.current_animation == "Punch":
	#	return
	
	#if $AnimationPlayer.current_animation == "walk":
	
	if(not player_in_range):
		if abs(Player.global_position.x - global_position.x) > 5:
			direction = (Player.global_position - global_position).normalized()
			
	#		if im looking to the left and Player is on the right side
			if Player.global_position.x > global_position.x && is_facing_left:
				scale.x = -scale.x
				is_facing_left = false
	#		if im looking to the right and Player is on the left side
			elif Player.global_position.x < global_position.x && not is_facing_left:
				scale.x = -scale.x
				is_facing_left = true
		velocity = direction * speed
		move_and_slide()
	else:
		
		if(ready_to_fire):
			var direction_to_player = (Player.global_position - marker_2d.global_position).normalized()
			firing_timer.start()
			ready_to_fire = false
			
			var projectile_instance = MAGE_PROJECTILE.instantiate()
			projectile_instance.global_position = marker_2d.global_position
			projectile_instance.rotation = direction_to_player.angle()
			get_tree().root.add_child(projectile_instance)
			
		print("piu piu atirando parado")
		

func hit() -> void:
	$AttackDetector.monitoring = true
	
func end_of_hit() -> void:
	$AttackDetector.monitoring = false

func walk () -> void :	
	$AnimationPlayer.play("walk")
	

# FUNÇÃO PRA QUANDO O TIRO ATINGE O INIMIGO
func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.get_parent().has_method("get_bullet_damage")):
		var node = area.get_parent() as Node
		hp -= node.get_bullet_damage()
		if(hp<=0):
			hurt_box.disabled = true
			sprite_2d.visible = false
			# ver se esse vai ter
			#death_soundplayer.play()
			Messages.add_xp.emit(xp_drop)
			#await death_soundplayer.finished
			queue_free()
			
			


func _on_fire_range_area_entered(area: Area2D) -> void:
	player_in_range = true


func _on_fire_range_area_exited(area: Area2D) -> void:
	player_in_range = false


func _on_firing_timer_timeout() -> void:
	ready_to_fire = true
	pass # Replace with function body.

# Fire rate
func set_fire_cooldown(ammount: float) -> void:
	firing_timer.wait_time = firing_timer.wait_time - (firing_timer.wait_time*ammount/100)
	print("time cooldown down to: ", firing_timer.wait_time)
