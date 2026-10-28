extends Control



@export var upgrade_index:int = -1
@onready var upgrade_name: Label = $upgrade_name
@onready var background: Sprite2D = $background
@onready var upgrades_parent: CanvasLayer = $"../../.."

@export var upgrades : Array[String] = [
	"+1 Piercing shot",
	"10% more fire-rate",
	"30% damage increase",
	]
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("EU SOU UMA CARTA, NASCI COM O INDEX", upgrade_index)
	upgrade_name.text = upgrades[upgrade_index]
	pass # Replace with function body.





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


	


func _on_texture_button_pressed() -> void:
	
	print("Botão com upgrade apertado: ",upgrades[upgrade_index])
	
	match upgrade_index:
		0: # +1 Piercing shot
			Messages.apply_piercing_upgrade.emit(1)
			
		1: # Fire rate %
			Messages.apply_percentage_fire_rate_upgrade.emit(10)
			
		2: #  damage increase
			Messages.apply_percentage_bullet_damage_upgrade.emit(30)
			
		3: #  projectiles increase
			Messages.increase_projectiles_ammount_upgrade.emit(1)
	
	Messages.upgrade_selected.emit()
	
	pass # Replace with function body.
