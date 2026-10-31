extends Node2D



@export var smokeScene : PackedScene
@onready var shotgun: Node2D = $"."
@onready var bullet_lifetime: Timer = $bullet_lifetime

@export var SPEED : int = 1500
@export var ttl : float = 2.5 #time to live
@export var bullet_damage : float = 5
@export var piercing_ammount : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	bullet_lifetime.wait_time = ttl
	bullet_lifetime.autostart = true
	bullet_lifetime.start()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x	* SPEED * delta
	


func _on_bullet_lifetime_timeout() -> void:
	#print("deleting bullet")
	queue_free()
	pass # Replace with function body.
	
func get_damage() -> float:
	return bullet_damage


func _on_hurt_box_body_entered(body: Node2D) -> void:
	print(body.get_parent())
	
	var smoke = smokeScene.instantiate() as GPUParticles2D
	get_parent().add_child(smoke)
	smoke.global_position = position
	smoke.rotation = rotation
 	
	
	piercing_ammount-=1
	if(piercing_ammount==0):
		queue_free()
		
	print("alguem entrou na bala")
