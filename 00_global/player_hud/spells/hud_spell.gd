extends Control

@onready var spell_sprite: AnimatedSprite2D = $spell_sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_sprite(index) -> void:
	match index:
		0: #fireball
			spell_sprite.play("fireball")
			
		1: # ice shard
			spell_sprite.play("ice-shard")
			
		2: #lightning
			spell_sprite.play("lightning")
	spell_sprite.visible = true
	pass
