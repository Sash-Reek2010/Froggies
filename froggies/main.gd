extends Node2D
@onready var countdown: Timer = $Countdown
@onready var time_label: Label = $CanvasLayer/TimeLabel
@onready var player = $Player

const PICKUPS_NEEDED := 10
const ROUND_SECONDS := 60.0

@onready var collect_label: Label = $CanvasLayer/CollectLabel

var collected_count := 0
var game_over := false

func _ready() -> void:
	countdown.timeout.connect(_on_countdown_timeout)

	for child in get_children():
		if child.has_signal("collected"):
			child.connect("collected", _on_collectible_picked_up)

	countdown.start(ROUND_SECONDS)

func _process(_delta: float) -> void:
	var seconds_left := ceili(countdown.time_left)
	var minutes := floori(seconds_left / 60.0)
	time_label.text = "%d:%02d" % [minutes, seconds_left % 60]

func _on_countdown_timeout() -> void:
	game_over = true
	time_label.text = "0:00"
	player.play_death()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		get_tree().change_scene_to_file("res://menu.tscn")
func _on_collectible_picked_up() -> void:
	if game_over:
		return

	collected_count += 1

	if collected_count == PICKUPS_NEEDED:
		collected_count = 0
		countdown.start(ROUND_SECONDS)

		for child in get_children():
			if child.has_method("reset_pickup"):
				child.call_deferred("reset_pickup")

	collect_label.text = "%d/%d" % [collected_count, PICKUPS_NEEDED]
