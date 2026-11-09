
extends Weapon

@export var magazine_size: int = 9
@export var currentAmmo: int = 9
@export var bullets_consumed_per_shot: int = 1

@onready var reload_timer: Timer = $reload_timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	super._ready()
	animated_sprite_2d.play("default")
	Messages.ammo_changed.emit(currentAmmo, magazine_size)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R:
			if(currentAmmo < magazine_size):
				currentAmmo = 0
				if(reload_timer.is_stopped()):
					animated_sprite_2d.play("reload")
					reload_timer.start()


func shoot() -> void:
	if (currentAmmo <= 0):
		return
	
	currentAmmo -= bullets_consumed_per_shot
	
	if (currentAmmo <= 0):
		if(reload_timer.is_stopped()):
			animated_sprite_2d.play("reload")
			reload_timer.start()
	
	Messages.ammo_changed.emit(currentAmmo, magazine_size)
	
	super.shoot()


func increase_projectiles_ammount(ammount: int) -> void:
	if projectiles_count == 0:
		bullet_spread = 0.3
	else:
		bullet_spread += 0.12
	projectiles_count += ammount


func _on_reload_timer_timeout() -> void:
	animated_sprite_2d.play("default")
	currentAmmo = magazine_size
	Messages.ammo_changed.emit(currentAmmo, magazine_size)
