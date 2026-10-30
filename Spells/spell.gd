extends Node2D


@export var spell_type: int = 0


@onready var spell_timer: Timer = $spell_timer
@onready var area_2d: Area2D = $Area2D
@onready var spell_range: CollisionShape2D = $Area2D/spell_range
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	match spell_type:
		0: # fireball
			cpu_particles_2d.visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
