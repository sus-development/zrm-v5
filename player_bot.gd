extends CharacterBody2D

const GRASS_STEP_01 = preload("res://Sound/grass_step_01.wav")
const GRASS_STEP_02 = preload("res://Sound/grass_step_02.wav")
const GRASS_STEP_03 = preload("res://Sound/grass_step_03.wav")
const GRASS_STEP_04 = preload("res://Sound/grass_step_04.wav")
const SNOW_STEP_01 = preload("res://Sound/snow_step_01.wav")
const SNOW_STEP_02 = preload("res://Sound/snow_step_02.wav")
const SNOW_STEP_03 = preload("res://Sound/snow_step_03.wav")
const SNOW_STEP_04 = preload("res://Sound/snow_step_04.wav")

const PICKUP_01 = preload("res://Sound/pickup_01.wav")
const PICKUP_02 = preload("res://Sound/pickup_02.wav")
const PICKUP_MEDKIT_01 = preload("res://Sound/pickup_medkit_01.wav")
const PICKUP_MEDKIT_02 = preload("res://Sound/pickup_medkit_02.wav")
const GRENADE_PREPARE = preload("uid://brrx5ku6x7b1n")

var SPEED = 300
var DELAY = 0
var HEALTH = 100
var VINOSLIVOST = 100

var RELOADING = false
var maybeselectedweapon = 0
var INCREMENT_DELAY = 0
var ogroundamount = 0

@export var MAX_VINOSLIVOST = 100
@export var REGULAR_SPEED = 300
@export var RUN_SPEED = 410
@export var P_BULLET = preload("res://bullet.tscn")

@onready var raycast = $RayCast2D
@onready var player: CharacterBody2D = $"../player"
@onready var navagent = $NavigationAgent2D

var SELECTED_WEAPON = 0
var WEAPONS = [	{
		"name": tr("$basicshotgun"),
		"id": 4,
		"class": "primary",
		"delay": 2.5,
		"automatic": false,
		"bullets": 6,
		"left_bullets": 6,
		"zapas_bullets": 24,
		"icon": "res://Resources/ui_stuff_lol/weapon_basicshotgun.png",
		"incremental_reload": true,
		"increment_sound": "res://Sound/shotgun_increment",
		"incremental_minusroundonreload": false,
		"increment_delay": 0.35,
		"type": "shotgun",
		"sway": 0.15,
		"weight": 0.40,
		"soundondelay": true,
		"delaysound": "res://Sound/shotgun_cycle.wav",
		"sound": "res://Sound/shotgun.wav",
	},]
var MOVEORDERS = []
var TARGET = []

enum AIStates {WANDERING, PATROLING, RETREATING, ACTIVE}
var State : AIStates = AIStates.WANDERING

var updatespeed = 0.9
var updatetimer = 0
var moveupdatespeed = 0.8
var moveupdatetimer = 0
var randrange = PI*2
var targetrotation = 0
var randdir = 0

func _ready() -> void:
	randdir = randf_range(-1, 1)
	navagent.velocity_computed.connect(Callable(_on_velocity_computed))

func _physics_process(delta: float) -> void:
	global_rotation = lerp_angle(global_rotation, targetrotation, 0.07)

	if State == AIStates.WANDERING:
		if updatetimer >= updatespeed:
			#targetrotation = global_rotation+(randf_range(-randrange, randrange))*0.7
			if MOVEORDERS.size() < 1:
				var randpoint = NavigationServer2D.map_get_closest_point(navagent.get_navigation_map(), global_position.lerp(NavigationServer2D.map_get_random_point(navagent.get_navigation_map(), 1, true), 0.25) ) 
				go(randpoint)
				targetrotation = global_position.angle_to_point(randpoint) + PI/randf_range(0.6, 2.1)
			updatetimer = 0
			


	if updatetimer <= updatespeed:
		updatetimer += 1 * delta
	#elif updatetimer >= updatespeed:
		#shoot()
		#if TARGET.size() < 1:
			#targetrotation = global_rotation+(randf_range(-randrange, randrange))*0.7
		#updatetimer = 0
		#
	#if moveupdatetimer <= moveupdatespeed:
		#moveupdatetimer += 1 * delta
	#elif moveupdatetimer >= moveupdatespeed:
		#shoot()
		#go(player.global_position)	
		#moveupdatetimer = 0


	if DELAY <= WEAPONS[SELECTED_WEAPON]["delay"]:
		DELAY += 5.3 * delta
		if DELAY >= WEAPONS[SELECTED_WEAPON]["delay"]/3.4 and WEAPONS[SELECTED_WEAPON]["left_bullets"] > 0 and WEAPONS[SELECTED_WEAPON]["soundondelay"]:
			$ReloadSound.stream = load(WEAPONS[SELECTED_WEAPON]["delaysound"])
			$ReloadSound.pitch_scale = randf_range(0.96, 1.04)
			$ReloadSound.play()
			
	if RELOADING and WEAPONS[SELECTED_WEAPON]["incremental_reload"]:
		if INCREMENT_DELAY >= WEAPONS[maybeselectedweapon]["increment_delay"]:
			INCREMENT_DELAY = 0
			$ReloadSound.stream = load(str(WEAPONS[maybeselectedweapon]["increment_sound"] + "_" + str(randi_range(1,5)).pad_zeros(2)) + ".wav")
			$ReloadSound.pitch_scale = randf_range(0.92, 1.04)
			$ReloadSound.play()
			WEAPONS[maybeselectedweapon]["left_bullets"] += 1
			WEAPONS[maybeselectedweapon]["zapas_bullets"] -= 1
			if WEAPONS[maybeselectedweapon]["zapas_bullets"] <= 0 or WEAPONS[SELECTED_WEAPON]["left_bullets"] == WEAPONS[SELECTED_WEAPON]["bullets"]:
				RELOADING = false
			if WEAPONS[SELECTED_WEAPON]["left_bullets"]	== WEAPONS[SELECTED_WEAPON]["bullets"] and !RELOADING and ogroundamount == 0:
				DELAY = WEAPONS[SELECTED_WEAPON]["delay"]				
	if INCREMENT_DELAY <= WEAPONS[SELECTED_WEAPON]["increment_delay"]:
		INCREMENT_DELAY += 1 * delta
		
	#if player != null:
	#	navagent.target_position = player.global_position		
	nav(delta)
	#move_and_slide()

func go(target: Vector2):
	MOVEORDERS.clear()
	if global_position.distance_to(target) >= 150:
		var midwaynotthefilm = global_position.lerp(target, 0.6)
		var split = global_position.distance_to(target) * 0.3
		var almostthere = NavigationServer2D.map_get_closest_point(navagent.get_navigation_map(), midwaynotthefilm + (global_position.direction_to(target).orthogonal() * split * randdir))
		MOVEORDERS.append(almostthere)
	MOVEORDERS.append(target)
	navagent.target_position = NavigationServer2D.map_get_closest_point(navagent.get_navigation_map(), MOVEORDERS.pop_front())

func nav(delta: float) -> void:
		
	if navagent.is_navigation_finished():
		if MOVEORDERS.size() > 0:
			navagent.target_position = NavigationServer2D.map_get_closest_point(navagent.get_navigation_map(), MOVEORDERS.pop_front())
		else:
			velocity = Vector2.ZERO
			return
	var nextpath: Vector2 = navagent.get_next_path_position()
	var newvelocity: Vector2 = (global_position.direction_to(nextpath) * SPEED)	
	if navagent.avoidance_enabled:
		navagent.set_velocity(newvelocity)
	else:
		_on_velocity_computed(newvelocity)
	#velocity = velocity.lerp(newvelocity, 0.2)

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = velocity.lerp(safe_velocity, 0.2)
	move_and_slide()

func ratata():
	if !WEAPONS[SELECTED_WEAPON]["automatic"] or WEAPONS[SELECTED_WEAPON]["type"] == "grenade" or RELOADING:
		return
	if WEAPONS[SELECTED_WEAPON]["left_bullets"] > 0 and DELAY >= WEAPONS[SELECTED_WEAPON]["delay"] and !RELOADING:
		shoot()	

func bullets_reload():
	match GamemodeManager.GAMEMODE:
		1:
			if (WEAPONS[SELECTED_WEAPON]["left_bullets"] == 0):
				WEAPONS[SELECTED_WEAPON]["left_bullets"] = WEAPONS[SELECTED_WEAPON]["bullets"]
				DELAY = 0
				$ReloadSound.pitch_scale = randf_range(0.94, 1.05)
				$ReloadSound.play()
		_:
			if WEAPONS[SELECTED_WEAPON]["incremental_reload"]:
				if WEAPONS[SELECTED_WEAPON]["left_bullets"] < WEAPONS[SELECTED_WEAPON]["bullets"] and WEAPONS[SELECTED_WEAPON]["zapas_bullets"] >= 1:
					maybeselectedweapon = SELECTED_WEAPON
										
					if WEAPONS[SELECTED_WEAPON]["incremental_minusroundonreload"] and WEAPONS[SELECTED_WEAPON]["left_bullets"] > 0 and !RELOADING:
						INCREMENT_DELAY = 0-WEAPONS[SELECTED_WEAPON]["increment_delay"]
						WEAPONS[SELECTED_WEAPON]["left_bullets"] -= 1
					elif !RELOADING:
						INCREMENT_DELAY = 0-WEAPONS[SELECTED_WEAPON]["increment_delay"]/2
					else:
						pass
					ogroundamount = WEAPONS[SELECTED_WEAPON]["left_bullets"]
					RELOADING = true
			else:
				if (WEAPONS[SELECTED_WEAPON]["left_bullets"] == 0) and (WEAPONS[SELECTED_WEAPON]["zapas_bullets"] >= WEAPONS[SELECTED_WEAPON]["bullets"]):
					WEAPONS[SELECTED_WEAPON]["left_bullets"] = WEAPONS[SELECTED_WEAPON]["bullets"]
					DELAY = 0
					WEAPONS[SELECTED_WEAPON]["zapas_bullets"] -= WEAPONS[SELECTED_WEAPON]["bullets"]
					WEAPONS[SELECTED_WEAPON]["zapas_bullets"] = max(0, WEAPONS[SELECTED_WEAPON]["zapas_bullets"])
					if WEAPONS[SELECTED_WEAPON]["type"] == "grenade":
						$ReloadSound.pitch_scale = randf_range(1.2, 1.35)
						$ReloadSound.stream = PICKUP_01
						$ReloadSound.play()
					else:
						$ReloadSound.pitch_scale = randf_range(0.94, 1.05)
						$ReloadSound.stream = load("res://Sound/pistol-reload.wav")
						$ReloadSound.play()

func shoot():
	if WEAPONS[SELECTED_WEAPON]["left_bullets"] != 0:
		if DELAY >= WEAPONS[SELECTED_WEAPON]["delay"]:
			# bullet.add_constant_force(get_global_mouse_position() - bullet.global_position)
			if WEAPONS[SELECTED_WEAPON]["type"] == "shotgun":	
				for i in 9:
					var bullet = P_BULLET.instantiate()
					bullet.shotgunbullet = true
					bullet.global_position = $Marker2D.global_position
					if WEAPONS[SELECTED_WEAPON]["left_bullets"] == WEAPONS[SELECTED_WEAPON]["bullets"]:
						bullet.global_rotation = global_rotation+(sin(randf_range(-64, 64)))*WEAPONS[SELECTED_WEAPON]["sway"]/1.5
					else:
						bullet.global_rotation = global_rotation+(sin(randf_range(-64, 64)))*WEAPONS[SELECTED_WEAPON]["sway"]					
					get_parent().add_child(bullet)
			else:
				var bullet = P_BULLET.instantiate()
				bullet.global_position = $Marker2D.global_position
				bullet.shotgunbullet = false
				if WEAPONS[SELECTED_WEAPON]["left_bullets"] == WEAPONS[SELECTED_WEAPON]["bullets"]:
					bullet.global_rotation = global_rotation+(sin(randf_range(-64, 64)))*WEAPONS[SELECTED_WEAPON]["sway"]/1.5
				else:
					bullet.global_rotation = global_rotation+(sin(randf_range(-64, 64)))*WEAPONS[SELECTED_WEAPON]["sway"]	
						
				get_parent().add_child(bullet)
			WEAPONS[SELECTED_WEAPON]["left_bullets"] -= 1
			WEAPONS[SELECTED_WEAPON]["left_bullets"] = max(0, WEAPONS[SELECTED_WEAPON]["left_bullets"])
			$ShootSound.pitch_scale = randf_range(0.93, 1.06)
			$ShootSound.stream = load(WEAPONS[SELECTED_WEAPON]["sound"])
			$ShootSound.play()
			DELAY = 0
			#print(DELAY)
	else:
		#$EmptySound.play()
		bullets_reload()
		DELAY = 0
		#print(DELAY)
