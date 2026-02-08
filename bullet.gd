extends RigidBody2D

var SPEED = 1450
var DAMAGE = 100
var shotgunbullet
var rngnum = 0
var rngnum2 = 0
var magnum = false
var PIERCETHRU = false

func _ready() -> void:
	if GamemodeManager.GAMEMODE == 3:
		# трижды весело
		var DATE = Time.get_date_string_from_system()
		var RNG = RandomNumberGenerator.new()
		DATE = str(DATE).replace("-", "")
		#print("date:" + str(hash(int(DATE/64))))
		RNG.seed = hash(DATE)
		rngnum = RNG.randi_range(0, 7)
		rngnum2 = RNG.randi_range(0, 9)
		
		if rngnum == 3:
			SPEED = 600
		elif rngnum == 6 or rngnum2 == 8:
			SPEED = 700
	if shotgunbullet:
		var bet = 0
		bet = randi_range(0, 2)
		if bet == 1:
			PIERCETHRU = true
		else:
			PIERCETHRU = false
	if magnum:
		DAMAGE *= 2
	else:
		pass
func _physics_process(delta):
	linear_velocity = Vector2(0, -SPEED).rotated(global_rotation)
	
