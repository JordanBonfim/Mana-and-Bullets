extends CharacterBody2D

const speed = 100

var Player: Node2D
var direction: Vector2 = Vector2.ZERO
var is_facing_left:bool = false




#region ENEMY STATS

var hp: float = 10
var max_hp: float = 10
var damage_to_player: float = 5
var xp_drop: float = 10
#endregion

var random = RandomNumberGenerator.new()

@onready var death_soundplayer: AudioStreamPlayer = $death_soundplayer
@onready var hurt_box: CollisionShape2D = $Area2D/hurt_box
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	$AnimationPlayer.play("walk")
	random.randomize()
	
	var half = get_viewport().get_visible_rect().size / 2
	
	var raio:int = sqrt(pow(half.x,2)+pow(half.y,2))
	var angulo:int = random.randi() % 360
	
	position.y = Player.global_position.y + raio*sin(angulo)
	position.x = Player.global_position.x + raio*cos(angulo)

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
	
	if(area.get_parent().has_method("get_bullet_damage")):
		
		var node = area.get_parent() as Node
		hp -= node.get_bullet_damage()
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
