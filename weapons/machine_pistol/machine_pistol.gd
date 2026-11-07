extends Node2D

const BULLET = preload("uid://c1jarv1c2wevn")

#region CONFIGURAÇÕES & REFERÊNCIAS
@export var smokeScene: PackedScene

@export_group("Stats da Arma")
@export var fire_delay_seconds: float = 0.5
@export var bullet_SPEED: int = 2200
@export var bullet_ttl: float = 1.5
@export var bullet_damage: float = 9
@export var bullet_piercing_ammount: int = 1
@export var bullet_spread: float = 0.0
@export var projectiles_count: int = 1
@export var magazine_size: int = 9
@export var currentAmmo: int = 9  
@export var bullets_consumed_per_shot: int = 1

@onready var muzzle: Marker2D = $muzzle
@onready var fire_cooldown: Timer = $fire_cooldown
@onready var firing_soundplayer: AudioStreamPlayer = $firing_soundplayer

var ready_to_fire: bool = true
@onready var reload_timer: Timer = $reload_timer

#endregion

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.play("default")
	
	fire_cooldown.wait_time = fire_delay_seconds
	fire_cooldown.one_shot = true
	
	# Garante a conexão do sinal de timeout
	if not fire_cooldown.timeout.is_connected(_on_fire_cooldown_timeout):
		fire_cooldown.timeout.connect(_on_fire_cooldown_timeout)

	# Sinais globais de upgrades
	Messages.apply_percentage_fire_rate_upgrade.connect(set_fire_cooldown)
	Messages.apply_piercing_upgrade.connect(increase_piercing)
	Messages.apply_percentage_bullet_damage_upgrade.connect(increase_damage_percentage)
	Messages.apply_fixed_bullet_damage_upgrade.connect(increase_damage_fixed)
	Messages.increase_projectiles_ammount_upgrade.connect(increase_projectiles_ammount)
	
	Messages.ammo_changed.emit(currentAmmo,magazine_size)
	
func _physics_process(_delta: float) -> void:
	# Rotação da arma apontando para o mouse
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0.0, 360.0)
	
	# Inverte a escala Y para não ficar de ponta-cabeça ao mirar para a esquerda
	scale.y = -1.0 if (rotation_degrees > 90.0 and rotation_degrees < 270.0) else 1.0
	
	# Disparo contínuo segurando o botão configurado no Input Map
	if Input.is_action_pressed("fire") and ready_to_fire:
		shoot()


func shoot() -> void:
	
	if (currentAmmo<=0):
		if(reload_timer.is_stopped()):
			animated_sprite_2d.play("reload")
			reload_timer.start()
		return
	
	currentAmmo -= bullets_consumed_per_shot
	Messages.ammo_changed.emit(currentAmmo,magazine_size)
		
	ready_to_fire = false
	fire_cooldown.start()
	
	if firing_soundplayer:
		firing_soundplayer.play()

	# Efeito de fumaça (1 por disparo)
	spawn_smoke()

	# Instanciação dos projéteis (com cálculo de dispersão)
	for i in range(projectiles_count):
		spawn_bullet(i)


func spawn_bullet(index: int) -> void:
	var bullet_instance = BULLET.instantiate()
	bullet_instance.global_position = muzzle.global_position
	
	# Cálculo do ângulo do projétil baseado na quantidade e spread
	if projectiles_count > 1:
		var angle_begin = rotation - (bullet_spread / 2.0)
		var angle_per_bullet = bullet_spread / float(projectiles_count - 1)
		bullet_instance.rotation = angle_begin + (angle_per_bullet * index)
	else:
		bullet_instance.rotation = rotation

	# Parâmetros da bala
	bullet_instance.SPEED = bullet_SPEED
	bullet_instance.ttl = bullet_ttl
	bullet_instance.bullet_damage = bullet_damage
	bullet_instance.piercing_ammount = bullet_piercing_ammount
	
	get_tree().root.add_child(bullet_instance)


func spawn_smoke() -> void:
	if not smokeScene:
		return
		
	var smoke = smokeScene.instantiate() as GPUParticles2D
	if smoke:
		get_parent().add_child(smoke)
		smoke.global_position = muzzle.global_position
		smoke.rotation = rotation


func _on_fire_cooldown_timeout() -> void:
	ready_to_fire = true


#region UPGRADES
func set_fire_cooldown(percentage: float) -> void:
	fire_cooldown.wait_time = max(0.05, fire_cooldown.wait_time * (1.0 - percentage / 100.0))
	print("Tempo de cooldown reduzido para: ", fire_cooldown.wait_time)

func increase_piercing(ammount: int) -> void:
	bullet_piercing_ammount += ammount

func increase_damage_percentage(percentage: float) -> void:
	bullet_damage += bullet_damage * (percentage / 100.0)

func increase_damage_fixed(ammount: float) -> void:
	bullet_damage += ammount

func increase_projectiles_ammount(ammount: int) -> void:
	if projectiles_count == 0:
		bullet_spread = 0.3
	else:
		bullet_spread += 0.12
	projectiles_count += ammount
#endregion


func _on_reload_timer_timeout() -> void:
	animated_sprite_2d.play("default")
	currentAmmo = magazine_size
	Messages.ammo_changed.emit(currentAmmo,magazine_size)
	
