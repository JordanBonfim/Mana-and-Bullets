extends Node2D



@onready var projectile_lifetime: Timer = $projectile_lifetime

@export var SPEED : int = 450
@export var ttl : float = 2 #time to live
@export var projectile_damage : float = 15
@export var piercing_ammount : int = 1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.autoplay = "default"
	animated_sprite_2d.play()
	projectile_lifetime.wait_time = ttl
	projectile_lifetime.autostart = true
	projectile_lifetime.start()
	
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x	* SPEED * delta
	


func _on_projectile_lifetime_timeout() -> void:
	#print("deleting bullet")
	queue_free()
	pass # Replace with function body.
	
func get_projectile_damage() -> float:
	return projectile_damage


func _on_hurt_box_body_entered(body: Node2D) -> void:
	
	#var smoke = smokeScene.instantiate() as GPUParticles2D
	#get_parent().add_child(smoke)
	#smoke.global_position = position
	#smoke.rotation = rotation
 	
	
	piercing_ammount-=1
	if(piercing_ammount==0):
		queue_free()
		
