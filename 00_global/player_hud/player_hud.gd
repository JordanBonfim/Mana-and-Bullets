#Player hud
extends CanvasLayer

#@onready var hp_margin_container: MarginContainer = $Control/HPMarginContainer
#@onready var hp_bar: TextureProgressBar = $Control/HPMarginContainer/NinePatchRect/HPBar
@onready var wave_counter_label: Label = $Control/Wave_counter

@export var wave_counter: int = 1

@onready var xp_bar: TextureProgressBar = $Control/xp_bar
@onready var level_label: Label = $Control/Level_label
@onready var fps_label: Label = $Control/FPS_label
@onready var life_container: HBoxContainer = $Control/Life_container
const HEART = preload("uid://bc5rbt6ehg1kl")
@onready var ammo_label: Label = $Control/ammo_label

@export var hearts: Array = [] 

const HUD_SPELL = preload("uid://dycegt5fdtgus")
@onready var spell_hbox_container: HBoxContainer = $Control/spell_Hbox_container


var spells_number: int = 2
var assigned_spells: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Messages.player_health_changed.connect(update_health_bar)
	Messages.increase_wave.connect(increase_wave_label)
	Messages.xp_changed.connect(xp_bar_update)
	Messages.leveled_up.connect(update_level_label)
	
	Messages.player_hit.connect(remove_heart)
	Messages.add_health.connect(add_heart)
	
	Messages.ammo_changed.connect(change_ammo)
	
	Messages.spell_selected.connect(inc_spells_assigned)
	
	for i in range(spells_number):
		var spell = HUD_SPELL.instantiate()
		spell_hbox_container.add_child(spell)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fps_label.text = str("FPS: ",Engine.get_frames_per_second())
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
	
	
func add_heart(ammount: int) -> void:
	#hearts.append(heart)
	print("criadno heart")
	var heart = HEART.instantiate()
	life_container.add_child(heart)
	
	
func remove_heart(ammount: int) -> void:
	for i in range(0, ammount):
		life_container.get_child(-1).queue_free()
	

func change_ammo(current_ammo: int, max_ammo:int) -> void:
	ammo_label.text = str(current_ammo,"/",max_ammo)
	

func inc_spells_assigned(index) -> void:
	var spell_frame = spell_hbox_container.get_child(assigned_spells)
	assigned_spells+=1
	spell_frame.set_sprite(index)
	
	
