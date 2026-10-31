extends CanvasLayer

const UPGRADE_CARD = preload("uid://cq5v5qx4f07e8")
@onready var h_box_container: HBoxContainer = $Control/HBoxContainer


var upgrades_number = 3
var spells_slots = 2

var random = RandomNumberGenerator.new()

const upgrades : Array[String] = [
	"+1 Piercing shot",
	"5% more fire-rate",
	"10% damage increse",
	"+1 projectiles"
	]
var upgrades_selected : Array[int] = []


@export var available_spells : Array[String] = [
	"Fire-ball",
	"ice-shard",
	"Venom",
	"thunder"
]
var spells_selected : Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Messages.leveled_up.connect(generate_upgrade)
	Messages.upgrade_selected.connect(clear_children_cards)
	random.randomize()
	pass
	
		
func generate_upgrade(new_level, levels_gained) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	for child in h_box_container.get_children():
		child.queue_free()
	upgrades_selected.clear()
	spells_selected.clear()
	visible = true
	
	var upgrade_type: int = 0
	if(spells_slots>0):
		upgrade_type = random.randi_range(0, 1)
	
	if(upgrade_type == 0):
		print("generating weapon upgrades")
		for i in range(0,upgrades_number):
			print("for 1 i:",i)
			var n = random.randi_range(0,upgrades.size()-1)
			while(n in upgrades_selected):
				n = random.randi_range(0,upgrades.size()-1)
			upgrades_selected.append(n)
			print("n:", n)
			print("array:", upgrades_selected)
		
		print("upgrades_selected[]", upgrades_selected)
		for i in range(upgrades_selected.size()):
			print("for 2 i:",i)
			
			var new_card = UPGRADE_CARD.instantiate()
			new_card.available_upgrades = upgrades
			new_card.upgrade_index = upgrades_selected[i]
			new_card.upgrade_type = 0
			h_box_container.add_child(new_card)
			
	elif (upgrade_type == 1):
		print("generating spells upgrades")
		spells_slots = spells_slots-1
		for i in range(0,upgrades_number):
			print("for 1 i:",i)
			var n = random.randi_range(0,available_spells.size()-1)
			while(n in spells_selected):
				n = random.randi_range(0,available_spells.size()-1)
			spells_selected.append(n)
			print("n:", n)
			print("array:", spells_selected)
		
		print("upgrades_selected[]", spells_selected)
		for i in range(spells_selected.size()):
			print("for 2 i:",i)
			
			var new_card = UPGRADE_CARD.instantiate()
			new_card.available_spells = available_spells
			new_card.upgrade_type = 1
			new_card.upgrade_index = spells_selected[i]
			h_box_container.add_child(new_card)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func clear_children_cards() -> void:
	for child in get_children():
		print("children:", child)
	visible = false
	pass
