extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


@onready var enemy_spawner: Node2D = $EnemySpawner
@onready var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player.play(0)
	Messages.leveled_up.connect(pause_game)
	Messages.upgrade_selected.connect(unpause_game)
	
	Messages.game_paused.connect(pause_game)
	Messages.game_unpaused.connect(unpause_game)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_audio_stream_player_finished() -> void:
	audio_stream_player.play(0)
	pass # Replace with function body.

func pause_game(l: int, i: int) -> void:
	get_tree().paused = true


func unpause_game() -> void:
	get_tree().paused = false
	
