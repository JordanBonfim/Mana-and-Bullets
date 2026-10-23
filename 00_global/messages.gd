extends Node

@warning_ignore("unused_signal")
signal player_health_changed(hp:float, max_hp:float)

@warning_ignore("unused_signal")
signal player_hit(damage:float)

@warning_ignore("unused_signal")
signal increase_wave(waves_to_increase: int)

@warning_ignore("unused_signal")
signal decrease_wave(waves_to_decrease: int)
