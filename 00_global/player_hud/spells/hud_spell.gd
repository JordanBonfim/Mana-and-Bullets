extends Control

@onready var spell_sprite: AnimatedSprite2D = $spell_sprite

var spell: Node2D

var spell_type = -1

@onready var cooldown_label: Label = $cooldown_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(spell != null and spell.has_method("get_cooldown") and spell_type != -1):
		if(spell.get_cooldown() > 0.0):
			cooldown_label.visible = true
		else:
			cooldown_label.visible = false
		cooldown_label.text = ("%0.f" % spell.get_cooldown())
		

func configure(index) -> void:
	match index:
		0: #fireball
			spell_sprite.play("fireball")
			
		1: # ice shard
			spell_sprite.play("ice-shard")
			
		2: #lightning
			spell_sprite.play("lightning")
	spell_sprite.visible = true
	if(spell != null and spell.has_method("get_cooldown") and spell_type != -1):
		cooldown_label.text = ("%0.f" % spell.get_cooldown())
	cooldown_label.visible = true
	pass
