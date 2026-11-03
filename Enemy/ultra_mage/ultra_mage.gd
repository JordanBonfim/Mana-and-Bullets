extends Enemy

const MAGE_PROJECTILE = preload("uid://c3cb5sedl8gx5")

var player_in_range: bool = false
var ready_to_fire: bool = true

@onready var firing_timer: Timer = $firing_timer
@onready var marker_2d: Marker2D = $Marker2D


func _ready() -> void:
	base_max_hp = 20
	base_damage_to_player = 20
	base_xp_drop = 15

	super._ready()


func _physics_process(delta: float) -> void:
	for effect in status_effects.keys():
		if status_effects[effect] > 0:
			status_effects[effect] -= delta
			
			match effect:
				"burning":
					apply_burning(delta)
				#"freezing":
					#apply_freezing()
	
	if(status_effects["freezing"] == 0.0):
		unapply_freezing()
	
	
	if not player_in_range:
		move_towards_player()
	elif ready_to_fire:
		fire_projectile()


func fire_projectile() -> void:
	var direction_to_player = (
		Player.global_position - marker_2d.global_position
	).normalized()

	firing_timer.start()
	ready_to_fire = false

	var projectile = MAGE_PROJECTILE.instantiate()
	projectile.global_position = marker_2d.global_position
	projectile.rotation = direction_to_player.angle()

	get_tree().root.add_child(projectile)


func _on_fire_range_area_entered(area: Area2D) -> void:
	player_in_range = true


func _on_fire_range_area_exited(area: Area2D) -> void:
	player_in_range = false


func _on_firing_timer_timeout() -> void:
	ready_to_fire = true


func set_fire_cooldown(amount: float) -> void:
	firing_timer.wait_time *= (1.0 - amount / 100.0)
