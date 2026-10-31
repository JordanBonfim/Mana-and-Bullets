extends CharacterBody2D



var Player: Node2D
var direction: Vector2 = Vector2.ZERO
var is_facing_left:bool = false


#region ENEMY STATS

const speed = 200

# base stats, updataded inside on_ready function
var base_max_hp: float = 10
var base_damage_to_player: float = 5
var base_xp_drop: float = 10

var hp: float = base_max_hp
var max_hp: float = base_max_hp
var damage_to_player: float = base_damage_to_player
var xp_drop: float = base_xp_drop

@export var growth_factor: float = 1
@export var quadratic_multiplier: float = 0.22
@export var wave_number : int = 1
#endregion

var random = RandomNumberGenerator.new()

@onready var death_soundplayer: AudioStreamPlayer = $death_soundplayer
@onready var hurt_box: CollisionShape2D = $Area2D/hurt_box
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D
@onready var hit_flash_animation: AnimationPlayer = $HitFlashAnimation


func _ready() -> void:
	$AnimationPlayer.play("walk")
	random.randomize()
	
	var half = get_viewport().get_visible_rect().size / 2
	
	var raio:int = sqrt(pow(half.x,2)+pow(half.y,2))
	var angulo:int = random.randi() % 360
	
	global_position = Player.global_position + Vector2(
	cos(angulo),
	sin(angulo)
	) * raio
	
	if(wave_number>1):
		max_hp = base_max_hp * pow(wave_number,2) * pow(growth_factor, wave_number - 1) * quadratic_multiplier
		hp = max_hp
		damage_to_player = base_damage_to_player * pow(wave_number,2) * pow(growth_factor, wave_number - 1) * quadratic_multiplier
		xp_drop = base_xp_drop * pow(wave_number,2) * pow(growth_factor, wave_number - 1) * (quadratic_multiplier - 0.1)
	print("--- SLIME SPAWNED ---")
	print("Wave: ", wave_number)
	print("HP: ", hp, "/", max_hp)
	print("Damage: ", damage_to_player)
	print("XP Drop: ", xp_drop)
	print("---------------------")
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		#cheatcode
		if event.keycode == KEY_1:
			queue_free()
	
func _physics_process(delta: float) -> void:
	
	#if $AnimationPlayer.current_animation == "Punch":
	#	return
	
	if $AnimationPlayer.current_animation == "walk":
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


func hit() -> void:
	$AttackDetector.monitoring = true

func end_of_hit() -> void:
	$AttackDetector.monitoring = false

func walk () -> void :	
	$AnimationPlayer.play("walk")

func _on_player_detector_body_entered(body: Node2D) -> void:
	#$AnimationPlayer.play("punch")
	#print("relou no player")
	Player.set_player_health(Player.hp-damage_to_player)

func _on_attack_detector_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()

# FUNÇÃO PRA QUANDO O TIRO ATINGE O INIMIGO
func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if(area.get_parent().has_method("get_damage")):
		
		var node = area.get_parent() as Node
		hp -= node.get_damage()
		
		hit_flash_animation.play("hit")
		
		if(hp<=0):
			hurt_box.set_deferred("disabled", true)
			sprite_2d.visible = false
			death_soundplayer.play()
			Messages.add_xp.emit(xp_drop)
			await death_soundplayer.finished
			queue_free()
		#print("enemy hp:",hp)
		
# @onready var hurt_box: CollisionShape2D = $Area2D/hurt_box
# @onready var sprite_2d: Sprite2D = $Sprite2D
