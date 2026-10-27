extends Control



@export var upgrade_index:int = -1
@onready var upgrade_name: Label = $upgrade_name
@onready var background: Sprite2D = $background
@onready var upgrades_parent: CanvasLayer = $"../../.."

const upgrades : Array[String] = [
	"+1 Piercing shot",
	"5% more fire-rate",
	"10% damage increase",
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
		#0: # +1 Piercing shot
		
		1: 
			Messages.apply_percentage_fire_rate_upgrade.emit(5)
		
		#2: #  damage increase
		
	
	Messages.upgrade_selected.emit()
	
	pass # Replace with function body.
