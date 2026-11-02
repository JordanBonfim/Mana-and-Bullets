extends Node2D


# Called when the node enters the scene tree for the first time.
@export var SPEED : int = 800
@export var ttl : float = 2 #time to live
@export var projectile_damage : float = 30
@export var piercing_ammount : int = 1

@export var spell_type : int = 0
var animation_name: String = ""

@onready var projectile_lifetime: Timer = $Projectile_lifetime


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# fireball
@export var burning_time_seconds = 0
@export var burning_damage = 0

# Ice shard
@export var freezing_time_seconds = 0




func _ready() -> void:
	match spell_type:
		0:
			animation_name = "fireball"
		1: 
			animation_name = "ice-shard"
	animated_sprite_2d.play(animation_name)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x	* SPEED * delta
	pass

func get_damage() -> float:
	return projectile_damage

func get_spell_type() -> int:
	return spell_type
	
func get_burning_time() -> float:
	return burning_time_seconds

func get_burning_damage() -> float:
	return burning_damage

func get_freezing_time() -> float:
	return freezing_time_seconds
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	piercing_ammount-=1
	if(piercing_ammount==0):
		queue_free()
	pass # Replace with function body.
