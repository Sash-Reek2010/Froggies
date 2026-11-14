extends Area2D

signal collected

var picked_up := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player" or picked_up:
		return

	picked_up = true
	hide()
	collected.emit()

func reset_pickup() -> void:
	picked_up = false
	show()
