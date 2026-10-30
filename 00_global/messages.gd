extends Node

# PLAYER HEALTH
@warning_ignore("unused_signal")
signal player_health_changed(hp:float, max_hp:float)

@warning_ignore("unused_signal")
signal player_hit(damage:float)


# WAVES 
@warning_ignore("unused_signal")
signal increase_wave(waves_to_increase: int)

@warning_ignore("unused_signal")
signal decrease_wave(waves_to_decrease: int)


# XP 
@warning_ignore("unused_signal")
signal leveled_up(new_level, levels_gained)

@warning_ignore("unused_signal")
signal xp_changed(current_xp, xp_to_next)

@warning_ignore("unused_signal")
signal add_xp(ammount: int)


# Upgrades
@warning_ignore("unused_signal")
signal apply_piercing_upgrade(piercing_ammount)

@warning_ignore("unused_signal") # like 10 or 20 more damage
signal apply_fixed_bullet_damage_upgrade(damage_ammount)

@warning_ignore("unused_signal") # like 10% or 20% more damage
signal apply_percentage_bullet_damage_upgrade(damage_ammount)

@warning_ignore("unused_signal") # fire rate %
signal apply_percentage_fire_rate_upgrade(decrease_ammount)

@warning_ignore("unused_signal") # Multiple shot
signal increase_projectiles_ammount_upgrade(ammount)

@warning_ignore("unused_signal") 
signal upgrade_selected()


# Spells
@warning_ignore("unused_signal")
signal spell_selected(index)
