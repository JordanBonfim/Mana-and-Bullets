extends CharacterBody2D

#region PLAYER STATS
var player_is_facing_left: bool = false

# Life
var hp: float = 1000:
	set(value):
		hp = clampf(value, 0, max_hp)
		Messages.player_health_changed.emit(hp, max_hp)

var max_hp: float = 1000:
	# Heal player every time health increases??? Think.
	set(value):
		max_hp = value
		Messages.player_health_changed.emit(hp, max_hp)

# Speed
@export var SPEED: float = 300.0
@export var speed_step: float = 50.0 # Passo de incremento/decremento para teste de velocidade

# Damage

# Xp
@export var player_level: int = 1
@export var player_xp: int = 0
@export var max_level: int = 100
@export var base_xp: int = 50
@export var growth_factor: float = 1.0
@export var quadratic_multiplier: float = 0.22
	
	
# SPELLS
const SPELL = preload("uid://c82n8qwqthm6b")


#endregion

@export var smokeScene: PackedScene
@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var zoom_step := 0.1
@export var min_zoom := 0.2
@export var max_zoom := 2.0
@onready var camera_2d: Camera2D = $Camera2D


func _ready() -> void:
	Messages.player_hit.connect(set_player_health)
	Messages.add_xp.connect(add_xp)
	Messages.spell_selected.connect(add_spell)
	


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera_2d.zoom = clamp(camera_2d.zoom - Vector2(zoom_step, zoom_step), Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera_2d.zoom = clamp(camera_2d.zoom + Vector2(zoom_step, zoom_step), Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().paused = !get_tree().paused
			
		# Controles de teste de HP e SPEED nas teclas - e +:
		# Ctrl + tecla = altera SPEED | Shift + tecla = altera max_hp | Tecla pura = altera hp
		elif event.keycode == KEY_MINUS or event.keycode == KEY_KP_SUBTRACT:
			if Input.is_key_pressed(KEY_CTRL):
				SPEED = max(0.0, SPEED - speed_step)
				print("SPEED TESTE:", SPEED)
			elif Input.is_key_pressed(KEY_SHIFT):
				max_hp -= 10
			else:
				print("LIFE:", hp)
				hp -= 2
		elif event.keycode == KEY_EQUAL or event.keycode == KEY_KP_ADD:
			if Input.is_key_pressed(KEY_CTRL):
				SPEED += speed_step
				print("SPEED TESTE:", SPEED)
			elif Input.is_key_pressed(KEY_SHIFT):
				max_hp += 10
			else:
				print("LIFE:", hp)
				hp += 2
				
		elif event.keycode == KEY_9:
			Messages.increase_wave.emit(1)
		elif event.keycode == KEY_E:
			add_xp(10)
		elif event.keycode == KEY_F:
			add_xp(100)


func _physics_process(_delta: float) -> void:
	# Vetor de entrada de movimento
	var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_direction != Vector2.ZERO:
		velocity = input_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	move_and_slide()

	# Orientação baseada no movimento horizontal (ignora se estiver parado ou apenas em Y)
	if input_direction.x < 0:
		player_is_facing_left = true
	elif input_direction.x > 0:
		player_is_facing_left = false
		
	# Atualiza o sprite
	atualizar_animacao(input_direction)


func atualizar_animacao(input_direction: Vector2) -> void:
	if not animated_sprite:
		return

	# Espelha o sprite com base no lado para onde o personagem andou por último
	animated_sprite.flip_h = player_is_facing_left

	# Alterna as animações
	if input_direction == Vector2.ZERO:
		animated_sprite.play("idle")
	elif SPEED > 250.0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("walk")


func set_player_health(health: float) -> void:
	hp = health


func _check_level_up() -> void:
	var levels_gained := 0

	while player_xp >= xp_to_next_level(player_level) and player_level < max_level:
		var xp_required = xp_to_next_level(player_level)
		player_xp -= xp_required
		player_level += 1
		levels_gained += 1
		print("emitindo com: player_xp", player_xp)
		print("emitindo com: xp_to_next_level", player_level)
		Messages.leveled_up.emit(player_level, 1)
	if levels_gained > 1:
		Messages.leveled_up.emit(player_level, levels_gained)
	Messages.xp_changed.emit(player_xp, xp_to_next_level(player_level))


func add_xp(ammount: int) -> void:
	if ammount <= 0:
		return
	player_xp += ammount
	Messages.xp_changed.emit(player_xp, xp_to_next_level(player_level))
	_check_level_up()


func xp_to_next_level(level: int) -> int:
	if level < 1:
		level = 1

	var xp = base_xp * pow(level, 2) * pow(growth_factor, level - 1) * quadratic_multiplier
	return int(round(xp))


func total_xp_for_level(target_level: int) -> int:
	var total := 0
	for i in range(1, target_level):
		total += xp_to_next_level(i)
	return total


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("get_projectile_damage"):
		var node = area.get_parent() as Node
		hp -= node.get_projectile_damage()
		if hp <= 0:
			print("JOGADOR MORREU")
			get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")


# SPELLS
func add_spell(spell_type: int) -> void:
	match spell_type:
		0: # Fireball
			var spell = SPELL.instantiate()
			spell.spell_type = spell_type 
			add_child(spell)
			
	
	
	pass
