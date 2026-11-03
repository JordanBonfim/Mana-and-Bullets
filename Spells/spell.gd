extends Node2D




const SPELL_PROJECTILE = preload("uid://be1qoo4m3tvh8")

@onready var spell_timer: Timer = $spell_timer
@onready var area_2d: Area2D = $Area2D
@onready var spell_range: CollisionShape2D = $Area2D/spell_range
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var marker_2d: Marker2D = $Marker2D

@export var spell_cooldown: float = 1.0
@export var spell_type: int = 0

@export var ready_spell: bool = true

# FIREBALL
@export var burning_time_seconds: float = 2.5
@export var burning_damage: float = 6

# ICE SHARD
@export var freezing_time_seconds: float = 1.2


var enemies_in_range: Array = []
var random = RandomNumberGenerator.new()

# area spells like aura will use this to target like all the enemies
var how_many_enemy_targets: int = 1  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	match spell_type:
		0: # fireball
			spell_range.scale = spell_range.scale*3
			spell_cooldown = 5.0
		1: # Ice-shard
			spell_cooldown = 10.0
			spell_range.scale = spell_range.scale*2.8
			
	spell_timer.wait_time = spell_cooldown
			#cpu_particles_2d.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(ready_spell == false):
		return
		
	if(enemies_in_range.size() > 0):
		ready_spell = false
		spell_timer.start()
		if(how_many_enemy_targets == 1 and enemies_in_range.size() > 0):
			var index = random.randi_range(0,enemies_in_range.size()-1)
			var enemy_position = enemies_in_range[index].global_position
			
			match spell_type:
				0: #Fire-ball
					var fireball = SPELL_PROJECTILE.instantiate()
					var direction_to_enemy = (enemy_position - marker_2d.global_position).normalized()
					fireball.global_position = marker_2d.global_position
					fireball.rotation = direction_to_enemy.angle()
					fireball.spell_type = spell_type
					fireball.burning_time_seconds = burning_time_seconds
					fireball.burning_damage = burning_damage
					fireball.projectile_damage = 5
					fireball.projectile_speed = 800
					get_tree().root.add_child(fireball)
					
				1: # Ice-shard
					var ice_shard = SPELL_PROJECTILE.instantiate()
					var direction_to_enemy = (enemy_position - marker_2d.global_position).normalized()
					ice_shard.global_position = marker_2d.global_position
					ice_shard.rotation = direction_to_enemy.angle()
					ice_shard.spell_type = spell_type
					ice_shard.freezing_time_seconds = freezing_time_seconds
					ice_shard.projectile_damage = 5
					ice_shard.projectile_speed = 800
					get_tree().root.add_child(ice_shard)
			
		


func _on_spell_timer_timeout() -> void:
	print("READY")
	ready_spell = true
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	enemies_in_range.append(area.get_parent())
	#print("enemies list:", enemies_in_range)

func _on_area_2d_area_exited(area: Area2D) -> void:
	enemies_in_range.erase(area.get_parent())
	#print("enemies list:", enemies_in_range)
