extends Timer

const ZONDRE = preload("res://zondre.tscn")
var rngnum = 0

func _on_timeout() -> void:
	if GamemodeManager.GAMEMODE == 3:
		var DATE = Time.get_date_string_from_system()
		var RNG = RandomNumberGenerator.new()
		var RNG2 = RandomNumberGenerator.new()
		DATE = int(str(DATE).replace("-", ""))
		#print("date:" + str(hash(int(DATE/64))))
		RNG.seed = hash(int(DATE))
		rngnum = RNG.randi_range(0, 19)
		if rngnum == 16:
			wait_time = randf_range(1.4, 3.8)
	elif GamemodeManager.GAMEMODE != 3 or rngnum != 16:
		wait_time = randf_range(2.5, 5)			
		
	if GamemodeManager.GAMEMODE == -1 and GamemodeManager.MODGAME["zondre_donotspawn"]:
		pass
	else:
		var zondrenew = ZONDRE.instantiate()
		zondrenew.position = $"..".position
		get_parent().get_parent().add_child(zondrenew)
