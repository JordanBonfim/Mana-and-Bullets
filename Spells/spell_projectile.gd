extends Node2D


# Called when the node enters the scene tree for the first time.
@export var SPEED : int = 800
@export var ttl : float = 2 #time to live
@export var projectile_damage : float = 30
@export var piercing_ammount : int = 1
@onready var projectile_lifetime: Timer = $Projectile_lifetime

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x	* SPEED * delta
	pass

func get_damage() -> float:
	return projectile_damage
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	piercing_ammount-=1
	if(piercing_ammount==0):
		queue_free()
	pass # Replace with function body.
