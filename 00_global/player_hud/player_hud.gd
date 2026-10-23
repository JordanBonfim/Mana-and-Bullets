#Player hud
extends CanvasLayer

#@onready var hp_margin_container: MarginContainer = $Control/HPMarginContainer
#@onready var hp_bar: TextureProgressBar = $Control/HPMarginContainer/NinePatchRect/HPBar
@onready var wave_counter_label: Label = $Control/Wave_counter

@export var wave_counter: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Messages.player_health_changed.connect(update_health_bar)
	Messages.increase_wave.connect(increase_wave_counter)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_health_bar(hp: float, max_hp: float) -> void:
	pass

func increase_wave_counter(waves_to_increase: int) -> void:
	wave_counter += waves_to_increase
	wave_counter_label.text = str("WAVE: ",wave_counter)
