extends Node2D


var SPEED : int = 1500
var ttl : float = 2.5 #time to live
var bullet_damage : float = 5
var piercing_ammount : int = 1


@export var timer: Timer
@export var smokeScene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = ttl
	timer.autostart = true
	timer.start()
	
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x	* SPEED * delta
	


func _on_timer_timeout() -> void:
	print("deleting bullet")
	queue_free()
	pass # Replace with function body.
	
func get_bullet_damage() -> float:
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
	
	
	
