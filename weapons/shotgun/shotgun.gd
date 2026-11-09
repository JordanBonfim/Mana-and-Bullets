extends Weapon

func _init() -> void:
	fire_delay_seconds = 0.8
	bullet_ttl = 0.4
	bullet_damage = 20.0
	bullet_spread = 0.5
	projectiles_count = 3


func increase_projectiles_ammount(ammount: int) -> void:
	if projectiles_count == 0:
		bullet_spread = 0.6
	else:
		bullet_spread += 0.12
	projectiles_count += ammount
