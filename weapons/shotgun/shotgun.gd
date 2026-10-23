extends Node2D


@export var ready_to_fire = true
@export var fire_delay_seconds:float = 0.4
@export var smokeScene : PackedScene

@onready var muzzle: Marker2D = $muzzle
@onready var fire_cooldown: Timer = $fire_cooldown


const BULLET = preload("uid://c1jarv1c2wevn")

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			shoot()

func shoot() -> void:
	if not ready_to_fire:
		return
		
	#var particle = Shot
		
func _physics_process(_delta: float) -> void:
	fire_cooldown.wait_time = fire_delay_seconds

	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	
		
	if Input.is_action_pressed("fire") :
		if(ready_to_fire):
			fire_cooldown.start()
			ready_to_fire = false
			var bullet_instance = BULLET.instantiate()
			get_tree().root.add_child(bullet_instance)
			bullet_instance.global_position = muzzle.global_position
			bullet_instance.rotation = rotation
			
			var smoke = smokeScene.instantiate() as GPUParticles2D
			get_parent().add_child(smoke)
			smoke.global_position = muzzle.global_position
			smoke.rotation = rotation

func _on_fire_cooldown_timeout() -> void:
	ready_to_fire = true
