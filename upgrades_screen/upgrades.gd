extends CanvasLayer

const UPGRADE_CARD = preload("uid://cq5v5qx4f07e8")
@onready var h_box_container: HBoxContainer = $Control/HBoxContainer


var upgrades_number = 3

var random = RandomNumberGenerator.new()

const upgrades : Array[String] = [
	"+1 Piercing shot",
	"5% more fire-rate",
	"10% damage increse",
	"+1 projectiles"
	]
var upgrades_selected : Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Messages.leveled_up.connect(generate_upgrade)
	Messages.upgrade_selected.connect(clear_children_cards)
	random.randomize()
	pass
	
		
func generate_upgrade(new_level, levels_gained) -> void:
	for child in h_box_container.get_children():
		child.queue_free()
	upgrades_selected.clear()
	visible = true
	
	
	for i in range(0,upgrades_number,1):
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
		new_card.upgrades = upgrades
		new_card.upgrade_index = upgrades_selected[i]
		h_box_container.add_child(new_card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func clear_children_cards() -> void:
	for child in get_children():
		print("children:", child)
	visible = false
	pass
