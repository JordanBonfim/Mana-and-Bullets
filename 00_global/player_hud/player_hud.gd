#Player hud
extends CanvasLayer

#@onready var hp_margin_container: MarginContainer = $Control/HPMarginContainer
#@onready var hp_bar: TextureProgressBar = $Control/HPMarginContainer/NinePatchRect/HPBar
@onready var wave_counter_label: Label = $Control/Wave_counter

@export var wave_counter: int = 1

@onready var xp_bar: TextureProgressBar = $Control/xp_bar
@onready var level_label: Label = $Control/Level_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Messages.player_health_changed.connect(update_health_bar)
	Messages.increase_wave.connect(increase_wave_label)
	Messages.xp_changed.connect(xp_bar_update)
	Messages.leveled_up.connect(update_level_label)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_health_bar(hp: float, max_hp: float) -> void:
	pass

func increase_wave_label(waves_to_increase: int) -> void:
	wave_counter += waves_to_increase
	wave_counter_label.text = str("WAVE: ",wave_counter)
	
func update_level_label(new_level: int, levels_gained: int) -> void:
	level_label.text = str("Level: ", new_level)

func xp_bar_update(new_xp, xp_to_next) -> void:
	xp_bar.max_value = xp_to_next
	xp_bar.value = new_xp
	#print("BAR VALUE:", xp_bar.value)
	#print("BAR max VALUE:", xp_bar.max_value)
	
