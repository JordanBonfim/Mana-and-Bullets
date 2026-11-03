class_name Enemy
extends CharacterBody2D

@export var original_speed: float = 200
@export var speed: float = original_speed
var Player: Node2D
var direction: Vector2 = Vector2.ZERO
var is_facing_left: bool = false

#region ENEMY STATS

@export var base_max_hp: float = 20
@export var base_damage_to_player: float = 10
@export var base_xp_drop: float = 10

var hp: float
var max_hp: float
var damage_to_player: float
var xp_drop: float

@export var growth_factor: float = 1
@export var quadratic_multiplier: float = 0.22
@export var wave_number: int = 1

#endregion

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurt_box: CollisionShape2D = $Area2D/Hurt_box
@onready var hit_flash_animation: AnimationPlayer = $HitFlashAnimation
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_number_position: Node2D = $DamageNumberPosition

var status_effects: Dictionary = {
	"burning": 0.0, # seconds duration
	"freezing": 0.0,
	"poison": 0.0
}

var status_effects_ammount: Dictionary = {
	"burning": 0.0, #damage
	"poison": 0.0 # damage
}
var burning_damage_timer: float = 0.0


func _ready() -> void:
	animation_player.play("walk")
	calculate_stats()
	spawn_around_player()


func calculate_stats() -> void:
	if wave_number <= 1:
		max_hp = base_max_hp
		hp = max_hp
		damage_to_player = base_damage_to_player
		xp_drop = base_xp_drop
		return

	var multiplier = pow(wave_number, 2) * pow(growth_factor, wave_number - 1) * quadratic_multiplier

	max_hp = base_max_hp * multiplier
	hp = max_hp
	damage_to_player = base_damage_to_player * multiplier
	xp_drop = base_xp_drop * multiplier * ((quadratic_multiplier - 0.1) / quadratic_multiplier)


func spawn_around_player() -> void:
	var half = get_viewport().get_visible_rect().size / 2
	var radius = half.length()
	var angle = randf_range(0, TAU)

	global_position = Player.global_position + Vector2(
		cos(angle),
		sin(angle)
	) * radius


func _physics_process(delta: float) -> void:
	for effect in status_effects.keys():
		if status_effects[effect] > 0:
			status_effects[effect] -= delta
			
			match effect:
				"burning":
					apply_burning(delta)
				#"freezing":
					#apply_freezing()
	
	if(status_effects["freezing"] == 0.0):
		unapply_freezing()
	
	move_towards_player()

func apply_burning(delta: float) -> void:
	if(hp>0):
		status_effects["burning"]
			
		burning_damage_timer += delta

		if burning_damage_timer >= 0.5:
			take_damage(status_effects_ammount["burning"])
			burning_damage_timer -= 0.5

func unapply_freezing() -> void:
	speed = original_speed
	
func move_towards_player() -> void:
	if abs(Player.global_position.x - global_position.x) > 5:
		direction = (Player.global_position - global_position).normalized()

	update_facing_direction()

	velocity = direction * speed
	move_and_slide()


func update_facing_direction() -> void:
	if Player.global_position.x > global_position.x and is_facing_left:
		scale.x = -scale.x
		is_facing_left = false

	elif Player.global_position.x < global_position.x and not is_facing_left:
		scale.x = -scale.x
		is_facing_left = true


func take_damage(damage: float) -> void:
	hp -= damage
	hit_flash_animation.play("hit")
	DamageNumbersSpawner.display_number(damage, damage_number_position.global_position, false)
	if hp <= 0:
		die()


func die() -> void:
	hurt_box.set_deferred("disabled", true)
	sprite_2d.visible = false

	#Messages.add_xp.emit(xp_drop)
	queue_free()


#func walk() -> void:
	#animation_player.play("walk")

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.has_method("get_damage"):
		take_damage(parent.get_damage())
	
	if parent.has_method("get_spell_type"):

		var spell_type:int = parent.get_spell_type()
		match spell_type:
			0: # Fireball
				status_effects["burning"] = parent.get_burning_time()
				status_effects_ammount["burning"] = parent.get_burning_damage()
				print("Burning ", parent.get_burning_damage())
				burning_damage_timer = 0.0
				
			1: # Ice-shard
				if(status_effects["freezing"] >= 0.0):
					speed = (speed * 60/100)
				status_effects["freezing"] = parent.get_freezing_time()
	
