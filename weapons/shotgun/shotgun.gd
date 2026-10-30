extends Node2D


const BULLET = preload("uid://c1jarv1c2wevn")

@export var ready_to_fire = true
@export var smokeScene : PackedScene
@onready var muzzle: Marker2D = $muzzle
@onready var fire_cooldown: Timer = $fire_cooldown
@onready var firing_soundplayer: AudioStreamPlayer = $firing_soundplayer

@export var bullet_SPEED : int = 2200 # original 1500
@export var bullet_ttl : float = 0.4 #time to live
@export var bullet_damage : float = 20
@export var bullet_piercing_ammount : int = 1
@export var bullet_spread : float = 0.5
@export var projectiles_count : int = 3
@export var fire_delay_seconds:float = 0.8 # original is 0.4

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			shoot()

func _ready() -> void:
	#Messages.player_health_changed.connect(update_health_bar)
	fire_cooldown.wait_time = fire_delay_seconds
	
	Messages.apply_percentage_fire_rate_upgrade.connect(set_fire_cooldown)
	Messages.apply_piercing_upgrade.connect(increase_piercing)
	Messages.apply_percentage_bullet_damage_upgrade.connect(increase_damage_percentage)
	Messages.apply_fixed_bullet_damage_upgrade.connect(increase_damage_fixed)
	Messages.increase_projectiles_ammount_upgrade.connect(increase_projectiles_ammount)

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
				
	if Input.is_action_pressed("fire") :
		if(ready_to_fire):
			for i in range(projectiles_count):
				fire_cooldown.start()
				ready_to_fire = false
				firing_soundplayer.play()
				var bullet_instance = BULLET.instantiate()
											
				bullet_instance.global_position = muzzle.global_position
				bullet_instance.rotation = rotation
				
				# with 2 bullets spread will begin with 0.5 rads
				if(projectiles_count > 1):
					var angle_begin = rotation - bullet_spread/2
					var angle_per_bullet = bullet_spread / (projectiles_count - 1)
					bullet_instance.rotation = angle_begin + (angle_per_bullet * i)
				
				bullet_instance.SPEED = bullet_SPEED
				bullet_instance.ttl = bullet_ttl
				bullet_instance.bullet_damage = bullet_damage
				bullet_instance.piercing_ammount = bullet_piercing_ammount
				
				get_tree().root.add_child(bullet_instance)
				
				var smoke = smokeScene.instantiate() as GPUParticles2D
				get_parent().add_child(smoke)
				smoke.global_position = muzzle.global_position
				smoke.rotation = rotation

# Fire rate
func set_fire_cooldown(ammount: float) -> void:
	fire_cooldown.wait_time = fire_cooldown.wait_time - (fire_cooldown.wait_time*ammount/100)
	print("time cooldown down to: ", fire_cooldown.wait_time)


func shoot() -> void:
	if not ready_to_fire:
		return
	#var particle = Shot
		

func _on_fire_cooldown_timeout() -> void:
	ready_to_fire = true

func increase_piercing(ammount: int) -> void:
	bullet_piercing_ammount += ammount
	
func increase_damage_percentage(ammount: int) -> void:
	bullet_damage = bullet_damage + (bullet_damage*ammount/100)

func increase_damage_fixed(ammount: int) -> void:
	bullet_damage += ammount
	
func increase_projectiles_ammount(ammount: int) -> void:
	if(projectiles_count == 0):
		bullet_spread = 0.6
	else:
		bullet_spread += 0.12
	projectiles_count += ammount
	
