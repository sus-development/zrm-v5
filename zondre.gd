extends CharacterBody2D

# ЗОНДРЕ НАХ 😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨
# ЗОНДРЕ НАХ 😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨
# ЗОНДРЕ НАХ 😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨
# ЗОНДРЕ НАХ 😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨
# ЗОНДРЕ НАХ 😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨
# ЗОНДРЕ НАХ 😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨
# ЗОНДРЕ НАХ 😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨
# ЗОНДРЕ НАХ 😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨
# ЗОНДРЕ НАХ 😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨
# ЗОНДРЕ НАХ 😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨

@onready var player: CharacterBody2D = $"../player"
@onready var navagent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer

const DEFAULT_SPEED = 217
var SPEED = 217
var HP = 100
var DAMAGE = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	match GamemodeManager.GAMEMODE:
		-1:
			pass
		1:
			DAMAGE = 100
			SPEED = DEFAULT_SPEED
		_:
			DAMAGE = 10
			SPEED = DEFAULT_SPEED
	if GamemodeManager.GAMEMODE == -1:
		if !GamemodeManager.MODGAME.has("zondre_damage") or GamemodeManager.MODGAME["zondre_damage"] == "default":
			DAMAGE = 10
		else:
			DAMAGE = int(GamemodeManager.MODGAME["zondre_damage"])
		if !GamemodeManager.MODGAME.has("zondre_speed") or GamemodeManager.MODGAME["zondre_speed"] == "default":
			SPEED = DEFAULT_SPEED
		else:
			SPEED = int(GamemodeManager.MODGAME["zondre_speed"])
			
	if GamemodeManager.GAMEMODE == 3:
		# дважды весело
		var DATE = Time.get_date_string_from_system()
		var RNG = RandomNumberGenerator.new()
		DATE = int(str(DATE).replace("-", ""))
		#print("date:" + str(hash(int(DATE/64))))
		RNG.seed = hash(int(DATE))
		var rngnum = RNG.randi_range(0, 4)
		var rngnum2 = RNG.randi_range(0, 6)
		if rngnum == 3:
			SPEED = 380
		if rngnum2 == 2:
			DAMAGE = 20
			
func _physics_process(delta: float) -> void:
	if HP <= 0:
		$".".queue_free()
	
	look_at($"../player".position)
	nav(delta)
	
func nav(delta: float) -> void:
	if navagent.is_navigation_finished():
		return
	var nextpath: Vector2 = navagent.get_next_path_position()
	var newvelocity: Vector2 = (global_position.direction_to(nextpath) * SPEED)
	position += newvelocity * delta


func _on_timer_timeout() -> void:
	if player != null:
		navagent.target_position = player.global_position

#func get_direction_to_player():
#	var player = get_tree().get_first_node_in_group("player") as Node2D
#	
#	if player != null:
#		return (player.global_position - global_position).normalized()
#	return Vector2.ZERO

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	if body.name == "player":
		body.HEALTH -= DAMAGE
	if body.is_in_group("danger_zombie"):
		HP -= body.DAMAGE
		player.SCORE += 1
		body.queue_free()
