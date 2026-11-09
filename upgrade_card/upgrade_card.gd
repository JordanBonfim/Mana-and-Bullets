extends Control

# 0 = normal upgrade
# 1 = spell selection

@export var upgrade_type:int = 0

@export var upgrade_index:int = -1
@onready var upgrade_name: Label = $upgrade_name
@onready var background: Sprite2D = $background

@export var available_upgrades : Array[String] = [
	"+1 Piercing shot",
	"10% more fire-rate",
	"30% damage increase",
	]

@export var available_spells : Array[String] = [
	"Fire-ball",
	"ice-shard",
	"Venom",
	"Singularity"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(upgrade_type == 0):
		upgrade_name.text = available_upgrades[upgrade_index]
	
	elif(upgrade_type == 1):	
		upgrade_name.text = available_spells[upgrade_index]
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_texture_button_pressed() -> void:
	
	
	if(upgrade_type == 0):
		print("Upgrade selecionado: ",available_upgrades[upgrade_index])
		match upgrade_index:
			0: # +1 Piercing shot
				Messages.apply_piercing_upgrade.emit(1)
				
			1: # Fire rate %
				Messages.apply_percentage_fire_rate_upgrade.emit(10)
				
			2: #  damage increase
				Messages.apply_percentage_bullet_damage_upgrade.emit(30)
				
			3: #  projectiles increase
				Messages.increase_projectiles_ammount_upgrade.emit(1)
				
	elif(upgrade_type == 1):
		print("Upgrade selecionado: ",available_spells[upgrade_index])
		Messages.spell_selected.emit(upgrade_index)
		
	Messages.upgrade_selected.emit()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	pass # Replace with function body.
