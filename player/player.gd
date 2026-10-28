extends CharacterBody2D

#region PLAYER STATS
var player_is_facing_left:bool = false

# Life
var hp: float = 100:
	set(value):
		hp = clampf(value, 0, max_hp) 
		Messages.player_health_changed.emit(hp, max_hp)
		
var max_hp:float = 100 :
	#Heal player every time health increases??? Think.
	set(value):
		max_hp = value 
		Messages.player_health_changed.emit(hp, max_hp)
	
# Speed
@export var SPEED = 300.0

# Damage

# Xp
@export var player_level: int  = 1
@export var player_xp: int  = 0
@export var max_level: int = 100
@export var base_xp: int = 50
@export var growth_factor: float = 1
@export var quadratic_multiplier: float = 0.22
	

#endregion

@export var smokeScene : PackedScene
@onready var timer: Timer = $Timer


@export var zoom_step := 0.1
@export var min_zoom := 0.2
@export var max_zoom := 2.0
@onready var camera_2d: Camera2D = $Camera2D


func _ready() -> void:
	#$AnimatedSprite2D.play("idle_main")
	Messages.player_hit.connect(set_player_health)
	Messages.add_xp.connect(add_xp)
	

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera_2d.zoom = clamp(camera_2d.zoom - Vector2(zoom_step, zoom_step), Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera_2d.zoom = clamp(camera_2d.zoom + Vector2(zoom_step, zoom_step), Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
	
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().paused = !get_tree().paused
		if event.keycode == KEY_MINUS:
			if Input.is_key_pressed(KEY_SHIFT):
				max_hp-=10
			else:
				print("LIFE:", hp)
				hp-=2
		elif event.keycode == KEY_EQUAL:
			if Input.is_key_pressed(KEY_SHIFT):
				max_hp+=10
			else:
				print("LIFE:", hp)
				hp+=2
		elif event.keycode == KEY_9:
			Messages.increase_wave.emit(1)
		
		elif event.keycode == KEY_E:
			#print("ADICIONANDO 10 DE XP")
			#print("PLAYER XP  ", player_xp)
			#print("PLAYER LEVEL  ", player_level)
			#print("XP TO NEXT LEVEL  ", xp_to_next_level(player_level))
			add_xp(10)
		elif event.keycode == KEY_F:
			#print("ADICIONANDO 100 DE XP")
			#print("PLAYER XP  ", player_xp)
			#print("PLAYER LEVEL  ", player_level)
			#print("XP TO NEXT LEVEL  ", xp_to_next_level(player_level))
			add_xp(100)
		
			
	#if event is InputEventMouseButton and event.pressed:
		#print("Clicked at:", event.position)
		#print("mouse position:", get_local_mouse_position())
		
	
		
	
func _physics_process(delta: float) -> void:
	
	# Handle jump.a
	#if Input.is_action_just_pressed("ui_accept") :
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var x_direction := Input.get_axis("ui_left", "ui_right")
	
	
	#$AnimatedSprite2D.flip_h = false
	if get_global_mouse_position().x < global_position.x:
		if not player_is_facing_left:
			player_is_facing_left = true
			#scale.x = -scale.x
	else:
		if player_is_facing_left:
			player_is_facing_left = false
			#scale.x = -scale.x
			
	if x_direction:
		velocity.x = x_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var y_direction := Input.get_axis("ui_up", "ui_down")
	if y_direction:
		velocity.y = y_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
	
	
func set_player_health(health : float) -> void:
	hp = health
	#if(hp <= 0):
	#	print("vida zerada")
   

func _check_level_up() -> void:
	var levels_gained := 0
	
	while player_xp >= xp_to_next_level(player_level) and player_level < max_level:
		var xp_required = xp_to_next_level(player_level)
		player_xp -= xp_required
		player_level += 1
		levels_gained += 1
		print("emitindo com: player_xp",player_xp)
		print("emitindo com: xp_to_next_level",player_level)
		Messages.leveled_up.emit(player_level, 1)
	if(levels_gained > 1 ):
		Messages.leveled_up.emit(player_level, levels_gained)
	Messages.xp_changed.emit(player_xp, xp_to_next_level(player_level ))
	
	
func add_xp(ammount: int) -> void:
	if ammount <= 0:
		return
	player_xp += ammount
	Messages.xp_changed.emit(player_xp, xp_to_next_level(player_level))
	_check_level_up()
	
	

func xp_to_next_level(level:int) -> int:
	if level < 1:
		level = 1
	
	var xp = base_xp * pow(level,2) * pow(growth_factor, level - 1) * quadratic_multiplier
	return int(round(xp))

func total_xp_for_level(target_level: int) -> int:
	var total := 0
	for i in range(1, target_level):
		total += xp_to_next_level(i)
	return total


# FUNÇÃO PRA QUANDO O TIRO ATINGE O INIMIGO
func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.get_parent().has_method("get_projectile_damage")):
		var node = area.get_parent() as Node
		hp -= node.get_projectile_damage()
		if(hp<=0):
			print("JOGADOR MORREU MANO")
			# ver se esse vai ter
			#death_soundplayer.play()
			#await death_soundplayer.finished
			get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")
