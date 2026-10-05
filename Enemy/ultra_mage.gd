extends CharacterBody2D

const speed = 100.0


var Player: Node2D

var last_position = position

var direction = 0
var is_facing_left:bool = false
var is_hitting_player:bool = false

#region ENEMY STATS

var hp: float = 100
var max_hp: float = 100
var damage_to_player: float = 5

#endregion

var random = RandomNumberGenerator.new()

func _ready() -> void:
	$AnimationPlayer.play("walk")
	random.randomize()
	
	var half = get_viewport().get_visible_rect().size / 2
	
	var raio:int = sqrt(pow(half.x,2)+pow(half.y,2))
	var angulo:int = random.randi() % 360
	print("Angulo:", angulo)
	
	position.y = Player.global_position.y + raio*sin(angulo)
	position.x = Player.global_position.x + raio*cos(angulo)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		
		if event.keycode == KEY_1:
			queue_free()
	
func _physics_process(delta: float) -> void:
	
	if $AnimationPlayer.current_animation == "Punch":
		return
	
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
	Player.set_player_health(Player.hp-damage_to_player)
	


func _on_attack_detector_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()
