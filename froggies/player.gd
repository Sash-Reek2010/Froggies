extends CharacterBody2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const BOUNCE_VELOCITY = -750.0
var bounced = false

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	pass
	
	

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite_2d.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite_2d.play("idle")
	
	animated_sprite_2d.flip_h = true if direction < 0 else false
	
	var was_on_floor := is_on_floor()
	move_and_slide()

	if is_on_floor() and not was_on_floor:
		if bounced:
			bounced = false
		else:
			velocity.y = BOUNCE_VELOCITY
			bounced = true
	
func play_death() -> void:
	set_physics_process(false)
	animated_sprite_2d.sprite_frames.set_animation_loop("death", false)
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished
	await get_tree().create_timer(0.75).timeout
	get_tree().change_scene_to_file("res://options.tscn")
