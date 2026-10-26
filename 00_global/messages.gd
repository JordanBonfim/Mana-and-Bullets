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
