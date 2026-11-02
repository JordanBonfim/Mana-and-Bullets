extends Enemy

func _ready() -> void:
	base_max_hp = 10
	base_damage_to_player = 5
	base_xp_drop = 10

	super._ready()


func _on_player_detector_body_entered(body: Node2D) -> void:
	Player.set_player_health(Player.hp - damage_to_player)


func _on_attack_detector_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()


func die() -> void:
	hurt_box.set_deferred("disabled", true)
	sprite_2d.visible = false

	$death_soundplayer.play()
	Messages.add_xp.emit(xp_drop)

	await $death_soundplayer.finished
	queue_free()
