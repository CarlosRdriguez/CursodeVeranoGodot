extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -200.0

# Referencia a tu nodo AnimatedSprite2D (asegúrate de que se llame así en tu escena)
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# 1. Agregar la gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Manejar el salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Obtener la dirección de entrada (-1 para izquierda, 1 para derecha, 0 si no hay tecla)
	var direction := Input.get_axis("ui_left", "ui_right")

	# --- CAMBIO DE DIRECCIÓN (FLIP) ---
	if direction < 0:
		animated_sprite.flip_h = false  # Mira hacia la derecha
	elif direction > 0:
		animated_sprite.flip_h = true   # Mira hacia la izquierda (espejo)

	# --- GESTIÓN DE ANIMACIONES ---
	if not is_on_floor():
		animated_sprite.play("jump")
	else:
		if direction != 0:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")

	# 4. Manejar el movimiento y desaceleración
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
