extends Node2D


# Called when the node enters the scene tree for the first time.
@export var ttl : float = 2 #time to live
@export var projectile_damage : float = 30
@export var piercing_ammount : int = 1
@export var projectile_speed : int = 200

@export var spell_type : int = 0
var animation_name: String = ""

@onready var projectile_lifetime: Timer = $Projectile_lifetime


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Fireball
@export var burning_time_seconds = 0
@export var burning_damage = 0

# Ice shard
@export var freezing_time_seconds = 0

# Lightning
@export var shocking_time_seconds: float = 0

# Singularity
@export var proc_damage: float = 4

@onready var area_2d: Area2D = $Area2D
@onready var proc_timer: Timer = $proc_timer
@onready var pulling_area_2d: Area2D = $pulling_area2d
@onready var cpu_particles_2d: CPUParticles2D = $pulling_area2d/CPUParticles2D


var enemies_inside_area_damage: Array = []

func _ready() -> void:
	match spell_type:
		0:
			animation_name = "fireball"
			projectile_lifetime.wait_time = 1.0
			
		1: 
			animation_name = "ice-shard"
			projectile_lifetime.wait_time = 1.0
			
		2:
			animation_name = "lightning"
			projectile_lifetime.wait_time = 1.0
		3:
			animation_name = "singularity"
			projectile_lifetime.wait_time = 6.0
			area_2d.scale = area_2d.scale*4
			animated_sprite_2d.scale=animated_sprite_2d.scale*4
			area_2d.monitorable = false
			area_2d.monitoring = true
			pulling_area_2d.monitorable = true
			pulling_area_2d.monitoring = true
			cpu_particles_2d.visible = true
			
			proc_timer.start()
			
			
	animated_sprite_2d.play(animation_name)
	projectile_lifetime.start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x	* projectile_speed * delta
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
	
func get_shocking_time() -> float:
	return shocking_time_seconds
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if(spell_type==3):
		enemies_inside_area_damage.append(area.get_parent())
		return
	piercing_ammount-=1
	if(piercing_ammount<=0):
		if(spell_type==2):
			animated_sprite_2d.sprite_frames.set_animation_loop("lightning", false)
			await animated_sprite_2d.animation_finished
		queue_free()
	


func _on_projectile_lifetime_timeout() -> void:
	queue_free()


func _on_proc_timer_timeout() -> void:
	print("trying to proc")
	if(enemies_inside_area_damage.size()>0):
		print("enemies in range: ", enemies_inside_area_damage)
		var enemy_index = randi_range(0, enemies_inside_area_damage.size()-1)
		var enemy: Node2D = enemies_inside_area_damage[enemy_index]
		if(enemy.has_method("take_damage")):
			enemy.take_damage(proc_damage)
		


func _on_area_2d_area_exited(area: Area2D) -> void:
	if(spell_type==3):
		enemies_inside_area_damage.erase(area.get_parent())


func _on_pulling_area_2d_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()
	if enemy.has_method("add_pulling_area"):
		enemy.add_pulling_area(global_position)


func _on_pulling_area_2d_area_exited(area: Area2D) -> void:
	var enemy = area.get_parent()
	if enemy.has_method("remove_pulling_area"):
		enemy.remove_pulling_area(global_position)
